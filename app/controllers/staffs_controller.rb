class StaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: %i[new create]

  def new
    @staff = User.new
  end

  def create
    @staff = User.new(staff_params.merge(role: :staff, organization_id: current_user.organization_id))

    if @staff.save
      flash[:notice] = 'Staff created successfully.'
      redirect_to authenticated_root_path # Updated to match your route
    else
      flash[:alert] = 'Failed to create staff.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def staff_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authorize_admin
    redirect_to root_path, alert: "Only admins can perform this action." unless current_user.admin?
  end
end
