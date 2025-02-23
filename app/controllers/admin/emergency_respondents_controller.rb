class Admin::EmergencyRespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @pending_users = User.emergency_respondents.where(verified: false, organization: current_user.organization)
    @respondents = current_user.organization.users
  end

  def verify
    @respondent = User.find(params[:id])
  
    if current_user.admin? && current_user.organization.status == "approved" && current_user.organization == @respondent.organization
      @respondent.update(verified: true)
      
      VerificationLog.create!(admin: current_user, respondent: @respondent, verified_at: Time.current)
  
      flash[:notice] = "Responder verified successfully."
    else
      flash[:alert] = "Unauthorized action."
    end
  
    redirect_to admin_emergency_respondents_path
  end
  
  

  def update
    @user = User.find(params[:id])
    
    if @user.update(verified: true)
      redirect_to admin_emergency_respondents_path, notice: "User verified successfully!"
    else
      redirect_to admin_emergency_respondents_path, alert: "Failed to verify user."
    end
  end

  private

  def ensure_admin
    unless current_user.admin? && current_user.organization.organization_type == "emergency_respondent"
      redirect_to root_path, alert: "Unauthorized!"
    end
  end

  def authorize_division_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.admin? && current_user.organization.status == "approved"
  end
end
