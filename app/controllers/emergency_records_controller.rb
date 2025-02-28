class EmergencyRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_emergency_access

  def search
    identifier = params[:identifier] # Expect a single identifier from the form
    @patient = Patient.find_by(national_identity_number: identifier) ||
               Patient.find_by(phone: identifier) ||
               Patient.find_by(voter_id: identifier)

    if @patient
      log_access(current_user, @patient)
      render :show
    else
      flash[:alert] = "Patient not found with the provided identifier!"
      redirect_to emergency_respondents_path
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end

  private

  def authorize_emergency_access
    unless current_user&.can_access_emergency_records?
      flash[:alert] = "Unauthorized access! Only verified emergency respondents can access patient records."
      redirect_to root_path
    end
  end

  def log_access(user, patient)
    EmergencyAccessLog.create!(
      user: user,
      patient: patient,
      accessed_at: Time.current
    )
    # Notify patient via email or SMS (future feature)
  end
end