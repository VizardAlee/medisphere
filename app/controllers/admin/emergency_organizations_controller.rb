class Admin::EmergencyOrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_super_admin

  def index
    @all_emergency_organizations = Organization.where(
      organization_type: "emergency"
    ).where("approved IS NULL OR approved = ?", false)
  end

  def approve
    @organization = Organization.find(params[:id])
    if @organization.update(approved: true, status: "approved")
      OrganizationMailer.approval_email(@organization).deliver_later
      flash[:notice] = "Organization approved successfully."
    else
      flash[:alert] = "Failed to approve organization."
    end
    redirect_to root_path
  end

  def reject
    @organization = Organization.find(params[:id])
    if @organization.update(approved: false, status: "rejected")
      OrganizationMailer.rejection_email(@organization).deliver_later
      flash[:alert] = "Organization has been rejected."
    else
      flash[:alert] = "Failed to reject organization."
    end
    redirect_to root_path
  end

  def update
    @organization = Organization.find(params[:id])
    if params[:approved] == "true"
      @organization.update(approved: true)
      flash[:notice] = "Emergency organization approved successfully."
    else
      @organization.destroy
      flash[:alert] = "Emergency organization rejected."
    end
    redirect_to admin_emergency_organizations_path
  end

  private

  def authorize_super_admin
    unless current_user.super_admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
