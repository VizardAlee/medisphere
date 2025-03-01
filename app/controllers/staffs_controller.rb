class StaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: %i[new create]
  before_action :set_staff, only: %i[edit update destroy show]
  layout "application", only: %i[edit update]


  def new
    @staff = User.new
  end

  def index
    @staffs = current_organization.users.staff
    if params[:staff_role].present? && params[:staff_role] != "All"
      if User.staff_roles.key?(params[:staff_role])
        @staffs = @staffs.where(staff_role: params[:staff_role])
      else
        flash[:alert] = "Invalid role selected"
      end
    end
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @staff = User.new(staff_params.except(:photo))
    @staff.role = :staff
    @staff.organization_id = current_user.organization_id
    @staff.staff_role = User.staff_roles[params[:user][:staff_role]] if params[:user][:staff_role].present?

    if staff_params[:photo].present?
      @staff.photo.attach(staff_params[:photo])
    end

    if @staff.save
      StaffMailer.welcome_email(@staff, staff_params[:password]).deliver_later
      flash[:notice] = "Staff created successfully, and a welcome email has been sent."
      redirect_to dashboard_path
    else
      Rails.logger.info "❌ Staff creation failed: #{@staff.errors.full_messages.join(', ')}"
      flash[:alert] = "Failed to create staff: #{@staff.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @staff.update(staff_params.except(:photo))
      if staff_params[:photo].present?
        @staff.photo.purge # Remove old photo if exists
        @staff.photo.attach(staff_params[:photo])
        Rails.logger.debug "Photo updated for staff ID #{@staff.id}: #{@staff.photo.attached?}"
      end
      flash[:notice] = "Staff updated successfully."
      redirect_to staff_path(@staff)
    else
      Rails.logger.debug "Staff update failed: #{@staff.errors.full_messages.join(', ')}"
      flash[:alert] = "Failed to update staff: #{@staff.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end
  
  def staff_params
    Rails.logger.debug "Received staff params: #{params[:user].inspect}"
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :staff_role, 
                                :qualification, :years_of_experience, :phone, :photo)
  end
  
  def save_uploaded_file(photo)
    filename = "#{SecureRandom.hex(10)}_#{photo.original_filename}"
    filepath = Rails.root.join('public', 'uploads', filename)
    FileUtils.mkdir_p(Rails.root.join('public', 'uploads')) # Ensure directory exists
    File.open(filepath, 'wb') { |f| f.write(photo.read) }
    "/uploads/#{filename}"
  rescue StandardError => e
    Rails.logger.error "Failed to save uploaded file: #{e.message}"
    nil
  end

  def destroy
    @staff.destroy
    @staffs = current_organization.users.staff

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("staff_list", partial: "staffs/staff_list", locals: { staff: @staffs })
      end
      format.html do
        redirect_to staffs_path, notice: "Staff deleted successfully."
      end
    end
  end
  
  

  def show
    @staff = User.find(params[:id])
  end

  private

  def set_staff
    @staff = User.find(params[:id])
    unless @staff
      flash[:alert] = "Staff not found."
      redirect_to staffs_path
    end
  end

  def staff_params
    Rails.logger.debug "Received staff_role: #{params[:user][:staff_role].inspect}"
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :staff_role, 
                                :qualification, :years_of_experience, :phone, :photo)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Only admins can perform this action." unless current_user.admin?
  end

  def save_uploaded_file(photo)
    filename = "#{SecureRandom.hex(10)}_#{photo.original_filename}"
    filepath = Rails.root.join('public', 'uploads', filename)
    FileUtils.mkdir_p(Rails.root.join('public', 'uploads')) # Ensure directory exists
    File.open(filepath, 'wb') { |f| f.write(photo.read) }
    "/uploads/#{filename}"
  end

  def current_organization
    current_user.organization
  end

end
