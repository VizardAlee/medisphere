# app/controllers/emergency_access_logs_controller.rb
class EmergencyAccessLogsController < ApplicationController
  before_action :authenticate_patient!

  def report
    @log = EmergencyAccessLog.find(params[:id])
    if @log.patient == current_patient
      respondent_organization = @log.user.organization
      super_admin = User.super_admin.find_by(
        state: @log.patient.organization.state,
        emergency_organization_type: respondent_organization.emergency_organization_type
      )
      if super_admin
        @log.update(reported: true)
        Rails.logger.info "Patient #{current_patient.name} reported access by #{@log.user.name} on #{@log.accessed_at}"
        AdminMailer.access_report_notification(current_patient, @log, super_admin).deliver_later
        redirect_to patient_path(current_patient), notice: "Access reported. The super admin has been notified."
      else
        redirect_to patient_path(current_patient), alert: "No super admin found."
      end
    else
      redirect_to patient_path(current_patient), alert: "Unauthorized action."
    end
  end
end