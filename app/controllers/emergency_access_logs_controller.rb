class EmergencyAccessLogsController < ApplicationController
  def report
    @log = EmergencyAccessLog.find(params[:id])
    if @log.patient == current_patient
      # In a real system, you'd notify admins or flag the log here
      Rails.logger.info "Patient #{current_patient.name} reported access by #{@log.user.name} on #{@log.accessed_at}"
      redirect_to patient_path(current_patient), notice: "Access reported. An administrator will review your report."
    else
      redirect_to patient_path(current_patient), alert: "Unauthorized action."
    end
  end
end