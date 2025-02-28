class OrganizationsController < ApplicationController
before_action :authenticate_user!
before_action :ensure_admin_or_super_admin, only: :show

  def new
    @organization = Organization.new
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

  def show
    @organization = Organization.find(params[:id])
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address, :phone, :organization_type)
  end

  def ensure_admin_or_super_admin
    unless current_user.admin? || current_user.super_admin?
      redirect_to root_path, alert: "Access denied. Only admins or super admins can view organization details."
    end
  end

  def ensure_admin
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
