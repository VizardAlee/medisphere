class Admin::OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_super_admin

  def index
    @organizations = Organization.where(status: "pending")
  end

  def approve
    @organization = Organization.find(params[:id])
    if @organization.update(approved: true, status: "approved")
      OrganizationMailer.approval_email(@organization).deliver_later
      flash[:notice] = "Organization approved successfully."
    else
      flash[:alert] = "Failed to approve organization."
    end
    redirect_to admin_organizations_path
  end
  
  def reject
    @organization = Organization.find(params[:id])
    if @organization.update(approved: false, status: "rejected")
      OrganizationMailer.rejection_email(@organization).deliver_later
      flash[:alert] = "Organization has been rejected."
    else
      flash[:alert] = "Failed to reject organization."
    end
    redirect_to admin_organizations_path
  end

  def appeal
    @organization = current_user.organization
  
    if request.patch?
      if @organization.update(appeal_status: "pending", appeal_reason: params[:organization][:appeal_reason])
        flash[:notice] = "Your appeal has been submitted."
        redirect_to root_path
      else
        flash[:alert] = "Failed to submit appeal."
      end
    end
  end
  
  

  private

  def authorize_super_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.super_admin?
  end
end
