class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user, unless: :devise_controller?
  # helper_method :current_user, :user_role

  # Handle unauthorized access
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # def authenticate_user
  #   unless current_user
  #     flash[:alert] = "You need to log in to access this page."
  #     redirect_to new_user_session_path
  #   end
  # end

  # def current_user
  #   # Define how to fetch the current user (e.g., using session)
  #   @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  # end

  def user_role
    current_user&.role || "visitor"
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  private

  # def public_page?
  #   request.path == new_user_session_path || request.path == new_user_registration_path || controller_name == "home"
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role])
  end
end
