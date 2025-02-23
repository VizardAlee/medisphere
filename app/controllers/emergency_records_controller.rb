class EmergencyRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_emergency_access

  def search
    @patient = Patient.find_by(national_identity_number: params[:id]) || 
               Patient.find_by(phone: params[:phone])

    if @patient
      log_access(current_user, @patient)
      render :show
    else
      flash[:alert] = "Patient not found!"
      redirect_to root_path
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end

  private

  def authorize_emergency_access
    unless current_user&.can_access_emergency_records?
      flash[:alert] = "Unauthorized access!"
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
