class EmergencyAccessController < ApplicationController
  before_action :authenticate_user!
  before_action :check_verification

  def show
    @patient = Patient.find(params[:id])
    # Logic for emergency access
  end

  private

  def check_verification
    unless current_user.verified? && current_user.organization.status == "approved"
      redirect_to root_path, alert: "Unauthorized! Your division is not approved or you are not verified."
    end
  end
end
