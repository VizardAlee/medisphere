class PatientMailer < ApplicationMailer
  def send_login_details
    @patient = params[:patient]
    @temporary_password = params[:temporary_password]
    mail(
      to: @patient.email,
      subject: "Your Login Details for MediSphere"
    )
  end

  def emergency_access_notification(patient, responder)
    @patient = patient
    @responder = responder
    mail(to: @patient.email, subject: "Emergency Access Notification")
  end
end
