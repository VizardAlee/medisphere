class StaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  def new
    @staff = User.new
  end

  def create
    @staff = User.new(staff_params)
    @staff.role = "staff"
    @staff.organization_id = current_user.organization_id
    if @staff.save
      flash[:notice] = "Staff created successfully."
      redirect_to admin_dashboard_path
    else
      flash.now[:alert] = "There was an error creating the staff member."
      render :new
    end
  end

  private

  def staff_params
    params.require(:user).permit(:email, :password, :password, :password_confirmation, :role)
  end

  def authorize_admin
    redirect_to root_path, alert: "Only admins can perform this action." unless current_user.admin?
  end
end
