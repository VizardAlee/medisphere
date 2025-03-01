class EmergencyRespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_emergency_admin, only: [:new, :create]
  before_action :authorize_super_admin, only: [:approve, :reject]
  before_action :set_respondent, only: [:approve, :reject, :edit, :update, :destroy]

  def index
    @emergency_organizations = current_user.organization ? [current_user.organization] : []
    @respondents = current_user.organization&.approved? ? User.where(role: "staff", organization_id: current_user.organization_id) : User.none
  end

  def new
    @respondent = User.new
  end

  def create
    @respondent = User.new(respondent_params)
    @respondent.role = "staff"
    @respondent.staff_role = "emergency_respondent"
    @respondent.organization = current_user.organization
    @respondent.verified = false
    @respondent.state = current_user.organization.state
    @respondent.emergency_organization_type = current_user.organization.emergency_organization_type

    if @respondent.save
      flash[:notice] = "Respondent created successfully. Awaiting super admin approval."
      redirect_to emergency_respondents_path
    else
      render :new
    end
  end

  def approve
    temp_password = SecureRandom.hex(8)
    if @respondent.update(verified: true, password: temp_password, password_confirmation: temp_password)
      RespondentMailer.verification_notification(@respondent, temp_password).deliver_later
      redirect_to dashboard_path, notice: "#{@respondent.name} has been approved. Notification sent."
    else
      redirect_to dashboard_path, alert: "Failed to approve #{@respondent.name}."
    end
  end

  def reject
    if @respondent.destroy
      redirect_to dashboard_path, notice: "#{@respondent.name} has been rejected."
    else
      redirect_to dashboard_path, alert: "Failed to reject #{@respondent.name}."
    end
  end

  private

  def respondent_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end

  def set_respondent
    @respondent = User.find(params[:id])
  end

  def authorize_emergency_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.emergency_admin?
  end

  def authorize_super_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user.super_admin?
  end
end