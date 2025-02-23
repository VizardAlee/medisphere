class EmergencyRespondentsController < ApplicationController
  before_action :set_organization, only: [:new, :create]
  before_action :authenticate_user!
  before_action :verify_emergency_respondent

  def index
    @respondents = current_user.organization.users
  end

  def new
    @user = User.new(role: :emergency_respondent, organization: @organization)
  end

  def create
    @organization = Organization.find_by(id: params[:token])
  
    if @organization.nil? || @organization.status != "approved"
      redirect_to root_path, alert: "Invalid or unapproved organization."
      return
    end
  
    @user = User.new(user_params)
    @user.role = :emergency_respondent
    @user.verified = false
    @user.organization = @organization
  
    if @user.save
      redirect_to root_path, notice: "Registration successful! Awaiting admin approval."
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  private

  def set_organization
    @organization = Organization.find_by(id: params[:token])
    redirect_to root_path, alert: "Invalid registration link" unless @organization
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end

  def verify_emergency_respondent
    unless current_user.staff? && current_user.staff_role == "emergency_respondent" && current_user.verified?
      redirect_to root_path, alert: "Unauthorized access"
    end
  end

  def check_organization_status
    if current_user.organization.status != "approved"
      redirect_to root_path, alert: "Your division is pending approval."
    end
  end
end
