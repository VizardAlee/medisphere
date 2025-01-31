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
      # Ensure params[:staff_role] is correctly mapped to the enum
      if User.staff_roles.key?(params[:staff_role]) # Check if the role exists in the enum
        @staffs = @staffs.where(staff_role: params[:staff_role])
      else
        flash[:alert] = "Invalid role selected"
      end
    end
  
    respond_to do |format|
      format.html # Standard HTML
      format.turbo_stream
    end
  end
  


  def create
    @staff = User.new(staff_params.merge(role: :staff, organization_id: current_user.organization_id))
    @staff.role = :staff  # Ensure the role is always 'staff'
    @staff.organization_id = current_user.organization_id # Assign organization

    @staff.staff_role = User.staff_roles[params[:user][:staff_role]] # Assign staff role

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
    # edit  staff
  end

  def update
    if @staff.update(staff_params)
      flash[:notice] = "Staff updated successfully."
      redirect_to staffs_path # Updated to match your route
    else
      Rails.logger.debug @staff.errors.full_messages
      flash[:alert] = "Failed to update staff."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @staff = User.find(params[:id])
    @staff.destroy
    @staffs = current_organization.users.staff # Fetch updated list of staff
  
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
    # Permit the staff_role field in the params
    Rails.logger.debug "Received staff_role: #{params[:user][:staff_role].inspect}"

    params.require(:user).permit(:name, :email, :password, :password_confirmation, :staff_role)
  end

  def authorize_admin
    # Ensure that only an admin can create staff
    redirect_to root_path, alert: "Only admins can perform this action." unless current_user.admin?
  end

end
