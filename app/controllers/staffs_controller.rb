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
    staff_email = staff_params[:email]
    temp_password = staff_params[:password]
  
    @staff = User.new(staff_params.merge(role: 'staff', organization_id: current_user.organization_id))
    @staff.password = temp_password
    @staff.password_confirmation = staff_params[:password_confirmation]
  
    if @staff.save
      StaffMailer.welcome_email(@staff, temp_password).deliver_later
      flash[:notice] = "Staff created successfully, and a welcome email has been sent."
      redirect_to authenticated_root_path
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
