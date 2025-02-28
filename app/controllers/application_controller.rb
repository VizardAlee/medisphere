class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_admin_profile, if: -> { current_user&.admin? && current_user.organization.nil? }
  before_action :authenticate_patient!, if: :patient_controller?
  before_action :authenticate_user_or_patient!,
  unless: -> { devise_controller? || (controller_name == "home" && action_name == "index" && request.get?) }

  def user_role
    current_user&.role || "visitor"
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for(resource)
    case resource
    when User
      case resource.role
      when 'super_admin'
        root_path
      when 'admin'
        resource.organization.nil? ? new_organization_path : root_path
      when 'staff'
        dashboard_path
      else
        root_path
      end
    when Patient
      patient_path(resource)
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def current_organization
    @current_organization ||= current_user.organization
  end

  def authenticate_patient!
    unless patient_signed_in?
      redirect_to new_patient_session_path, alert: "You need to sign in as a patient."
    end
  end
  
  def authenticate_user_or_patient!
    unless current_user || current_patient
      redirect_to new_user_session_path, alert: "You need to sign in first."
    end
  end

  def authorize_super_admin!
    unless current_user&.super_admin? &&
          current_user.state == @organization.state &&
          current_user.emergency_organization_type == @organization.emergency_organization_type
      flash[:alert] = "Access denied. You can only manage organizations in your state and department."
      redirect_to root_path
    end
  end

  helper_method :current_organization

  private

  def check_admin_profile
    return unless current_user.admin?

    if current_user.organization.blank? || !organization_profile_complete?(current_user.organization)
      redirect_to new_organization_path
    end
  end

  def organization_profile_complete?(organization)
    organization.name.present? && organization.address.present? && organization.phone.present?
  end

  def authorize_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end

  def patient_controller?
    controller_path.start_with?('patients/')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role organization_id phone])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])

    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :organization_name, :organization_address, :organization_phone, :organization_type, :state, :emergency_division])  end
end
