class SharedSessionsController < ApplicationController
  # Skip authentication since this is the login action
  skip_before_action :authenticate_user!
  skip_before_action :authenticate_user_or_patient!, only: [:new, :create, :destroy]

  def new
    # Render a shared login form (see below)
  end

  def create
    login    = params[:user][:login]
    password = params[:user][:password]

    # Try to find a User record (assuming User uses Devise’s valid_password? method)
    user = User.find_for_database_authentication(login: login)
    if user && user.valid_password?(password)
      sign_in(:user, user)
      redirect_to after_sign_in_path_for(user) and return
    end

    # If not found or invalid, try to find a Patient record
    patient = Patient.find_for_database_authentication(login: login)
    # For Patient, since we used has_secure_password, use authenticate:
    if patient && patient.authenticate(password)
      sign_in(:patient, patient)
      redirect_to after_sign_in_path_for(patient) and return
    end

    flash.now[:alert] = "Invalid login credentials."
    render :new
  end

  def destroy
    reset_session # Ensure full logout
    redirect_to root_path, notice: "You have successfully signed out."
  end
end
