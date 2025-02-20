class CustomFailure < Devise::FailureApp
  def respond
    if request.format == :html
      flash[:error] = i18n_message
      redirect_to send("new_#{scope_name}_session_path")
    else
      http_auth
    end
  end

  private

  def scope_name
    Devise.mappings.keys.first # Gets the first Devise scope (e.g., :user)
  end
end
