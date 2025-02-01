class CustomFailure < Devise::FailureApp
  def respond
    if request.format == :html
      flash[:error] = i18n_message
      redirect_to new_session_path(scope)
    else
      http_auth
    end
  end
end
