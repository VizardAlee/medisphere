# app/controllers/respondents_controller.rb
class RespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_respondent

  def index
    Rails.logger.info "Respondent index accessed with params: #{params.inspect}"
    if params[:query].present?
      @patient = Patient.find_by(phone: params[:query])
      if @patient
        @latest_health_record = HealthRecord.where(patient_id: @patient.id).order(id: :desc).first
        EmergencyAccessLog.create(
          patient: @patient,
          user: current_user,
          accessed_at: Time.current
        )
        PatientMailer.emergency_access_notification(@patient, current_user).deliver_later
        Rails.logger.info "Patient found: #{@patient.phone}"
      else
        Rails.logger.info "No patient found for query: #{params[:query]}"
      end
    end
  end

  private

  def ensure_respondent
    redirect_to root_path, alert: "Unauthorized access" unless current_user.staff? && current_user.emergency_respondent?
  end
end