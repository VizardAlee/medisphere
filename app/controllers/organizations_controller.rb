class OrganizationsController < ApplicationController
before_action :authenticate_user!
before_action :ensure_admin

  def new
    @organization
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.users << current_user

    if @organization.save
      current_user.update(organization: @organization)
      redirect_to dashboard_path, notice: "Organization profile created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address, :phone)
  end

  def ensure_admin
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
