class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.super_admin?
      @organizations = Organization.where(
        organization_type: "emergency",
        state: current_user.state,
        emergency_organization_type: current_user.emergency_organization_type,
        approved: [nil, false]
      )
      @pending_respondents = User.where(
        role: "staff",
        staff_role: "emergency_respondent",
        verified: false,
        state: current_user.state,
        emergency_organization_type: current_user.emergency_organization_type
      )
    elsif current_user.emergency_admin?
      redirect_to emergency_respondents_path
    else
      redirect_to root_path, alert: "Unauthorized access"
    end
  end
end