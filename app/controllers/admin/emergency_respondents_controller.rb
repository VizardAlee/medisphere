class Admin::EmergencyRespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_super_admin

  def index
    @pending_respondents = User.where(role: "staff", staff_role: "emergency_respondent", verified: false, organization: Organization.where(state: current_user.state))
    @organizations = Organization.where(status: "pending", state: current_user.state)
    @reported_access_logs = EmergencyAccessLog.joins(patient: :organization)
                                              .where(organizations: { state: current_user.state })
                                              .order(accessed_at: :desc)
  end

  def verify
    @respondent = User.find(params[:id])
    temp_password = SecureRandom.hex(8) # Generates a 16-character random password (e.g., "a1b2c3d4e5f6g7h8")
    if @respondent.update(verified: true, password: temp_password, password_confirmation: temp_password)
      RespondentMailer.verification_notification(@respondent, temp_password).deliver_later
      flash[:notice] = "Respondent verified successfully. They have been sent an email with their login credentials."
    else
      flash[:alert] = "Failed to verify respondent: #{@respondent.errors.full_messages.join(', ')}"
    end
    redirect_to root_path
  end

  private

  def authorize_super_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.super_admin?
  end
end