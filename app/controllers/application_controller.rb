class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_admin_profile, if: -> { current_user&.admin? && current_user.organization.nil? }
  # before_action :authenticate_user, unless: :devise_controller?
  # helper_method :current_user, :user_role

  def user_role
    current_user&.role || "visitor"
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for(resource)
    if resource.admin? && resource.organization.nil?
      new_organization_path
    else
      root_path
    end
  end

  private

  def check_admin_profile
    if controller_name != "organizations" && action_name != "new"
      flash[:alert] = "Please complete your organization profile to continue."
      redirect_to new_organization_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role organization_id])
  end
end
