class AdminMailer < ApplicationMailer
  def access_report_notification(patient, log, super_admin)
    @patient = patient
    @log = log
    @super_admin = super_admin
    mail(to: @super_admin.email, subject: "Emergency Access Report from #{@patient.name} in #{@super_admin.state}")
  end
end
