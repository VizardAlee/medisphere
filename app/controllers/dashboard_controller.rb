class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    Rails.logger.debug "Current user role: #{current_user.role}, org type: #{current_user.organization&.organization_type}"
    if current_user.super_admin?
      @organizations = Organization.where(
        organization_type: "emergency",
        state: current_user.state,
        emergency_organization_type: current_user.emergency_organization_type
      ).where("approved IS NULL OR approved = ?", false)

      @pending_respondents = User.where(
        role: "staff",
        staff_role: "emergency_respondent",
        verified: false,
        state: current_user.state,
        emergency_organization_type: current_user.emergency_organization_type
      )
      Rails.logger.debug "Super admin rendering emergency_dashboard"
      render :emergency_dashboard # Explicitly render if needed
    elsif current_user.emergency_admin?
      redirect_to emergency_respondents_path
    elsif current_user.admin?
      @organization = current_user.organization
      @staffs = User.where(organization_id: @organization.id, role: User.roles[:staff])
    elsif current_user.staff? && current_user.emergency_respondent?
      redirect_to respondent_path
    elsif current_user.staff?
      @organization = current_user.organization
      @patients = Patient.where(organization_id: @organization.id)
      render :staff_dashboard
    else
      redirect_to root_path, alert: "Unauthorized access"
    end
  end
end