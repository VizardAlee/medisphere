class StaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: %i[new create]

  def new
    @staff = User.new
  end

  def index
    @staffs = current_organization.users
    @staffs = @staffs.where(staff_role: params[:staff_role]) if params[:staff_role].present?
  
    respond_to do |format|
      format.html # Standard HTML
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "staff_list", 
          partial: "staffs/staff_list", 
          locals: { staff: @staffs }
        )
      end
      format.any { head :not_acceptable }
    end
  end
  

  def create
    Rails.logger.info("Staff params: #{staff_params.inspect}")

    # Include the staff_role in the user creation process and ensure role is set to 'staff'
    generated_password = SecureRandom.hex(8)
    @staff = User.new(
      staff_params.merge(
        role: :staff,
        organization_id: current_user.organization_id,
        password: generated_password,
        password_confirmation: generated_password
      )
    )

    if @staff.save
      StaffMailer.welcome_email(@staff, generated_password).deliver_later

      flash[:notice] = "Staff created successfully."
      redirect_to authenticated_root_path # Updated to match your route
    else
      flash[:alert] = "Failed to create staff."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @staff = User.find(params[:id])
  end

  def update
    if @staff.update(staff_params)
      flash[:notice] = "Staff updated successfully."
      redirect_to authenticated_root_path # Updated to match your route
    else
      flash[:alert] = "Failed to update staff."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @staff = User.find(params[:id])
    @staff.destroy
    @staffs = User.where(role: 'staff') # Get the updated list of staff
  
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("staff-list", partial: "staffs/staff_list", locals: { staff: @staffs })
      end
      format.html { redirect_to staffs_path, notice: "Staff deleted successfully." }
    end
  end
  
  

  def show
    @staff = User.find(params[:id])
  end

  private

  def set_staff
    @staff = User.find(params[:id])
  end

  def staff_params
    # Permit the staff_role field in the params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :staff_role)
  end

  def authorize_admin
    # Ensure that only an admin can create staff
    redirect_to root_path, alert: "Only admins can perform this action." unless current_user.admin?
  end

end
