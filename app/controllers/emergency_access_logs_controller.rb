class EmergencyAccessLogsController < ApplicationController
  before_action :authenticate_patient!

  def report
    @log = EmergencyAccessLog.find(params[:id])
    if @log.patient == current_patient
      patient_state = @log.patient.organization&.state
      if patient_state.present?
        super_admin = User.super_admin.find_by(state: patient_state)
        if super_admin
          Rails.logger.info "Patient #{current_patient.name} reported access by #{@log.user.name} on #{@log.accessed_at}"
          AdminMailer.access_report_notification(current_patient, @log, super_admin).deliver_later
          redirect_to patient_path(current_patient), notice: "Access reported. The super admin for your state (#{patient_state}) has been notified and will review your report."
        else
          Rails.logger.warn "No super admin found for state: #{patient_state}"
          redirect_to patient_path(current_patient), alert: "Access reported, but no super admin is assigned to your state (#{patient_state})."
        end
      else
        Rails.logger.warn "Patient organization state is missing for patient ID: #{@log.patient.id}"
        redirect_to patient_path(current_patient), alert: "Access reported, but your organization’s state is not set. Contact support."
      end
    else
      redirect_to patient_path(current_patient), alert: "Unauthorized action."
    end
  end
end