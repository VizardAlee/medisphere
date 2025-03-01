class RespondentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_respondent

  def index
    if params[:query].present?
      @patient = Patient.find_by(phone: params[:query])
      if @patient
        @latest_health_record = HealthRecord.where(patient_id: @patient.id).order(id: :desc).first
      end
    end
  end

  private

  def ensure_respondent
    redirect_to root_path, alert: "Unauthorized access" unless current_user.staff? && current_user.emergency_respondent?
  end
end