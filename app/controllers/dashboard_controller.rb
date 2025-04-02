class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_super_admin, only: [:emergency_dashboard]

  def index
    Rails.logger.debug "Current user role: #{current_user.role}, org type: #{current_user.organization&.organization_type}"
    if current_user.super_admin?
      emergency_dashboard # Call the emergency_dashboard logic directly
      render :emergency_dashboard
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
    else
      redirect_to root_path, alert: "Unauthorized access"
    end
  end

  def emergency_dashboard
    @pending_respondents = User.where(
      role: "staff",
      staff_role: "emergency_respondent",
      verified: false,
      organization: Organization.where(state: current_user.state, emergency_organization_type: current_user.emergency_organization_type)
    )
    @approved_respondents = User.where(
      role: "staff",
      staff_role: "emergency_respondent",
      verified: true,
      organization: Organization.where(state: current_user.state, emergency_organization_type: current_user.emergency_organization_type)
    )
    @pending_organizations = Organization.where(
      organization_type: "emergency",
      state: current_user.state,
      emergency_organization_type: current_user.emergency_organization_type,
      status: "pending"
    )
    @approved_organizations = Organization.where(
      organization_type: "emergency",
      state: current_user.state,
      emergency_organization_type: current_user.emergency_organization_type,
      status: "approved"
    )
    @reported_access_logs = EmergencyAccessLog.joins(patient: :organization)
                                              .where(organizations: { state: current_user.state, emergency_organization_type: current_user.emergency_organization_type })
                                              .order(accessed_at: :desc)
  end

  private

  def authorize_super_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.super_admin?
  end
end