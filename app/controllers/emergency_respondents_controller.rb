class EmergencyRespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_emergency_admin

  def index
    @emergency_organizations = current_user.organization ? [current_user.organization] : []
    @respondents = current_user.organization&.approved? ? User.where(role: "staff", organization_id: current_user.organization_id) : User.none
  end

  private

  def authorize_emergency_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.emergency_admin?
  end
end