class Admin::EmergencyRespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_super_admin

  def index
    @pending_respondents = User.where(role: "staff", staff_role: "emergency_respondent", verified: false)
  end

  def verify
    @respondent = User.find(params[:id])
    if @respondent.update(verified: true)
      temp_password = SecureRandom.hex(8) # Temporary password
      @respondent.update(password: temp_password, password_confirmation: temp_password)
      RespondentMailer.verification_notification(@respondent, temp_password).deliver_later
      flash[:notice] = "Respondent verified successfully. Notification email sent."
    else
      flash[:alert] = "Failed to verify respondent."
    end
    redirect_to root_path # Changed from admin_emergency_respondents_path
  end

  private

  def authorize_super_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.super_admin?
  end
end