class RespondentMailer < ApplicationMailer
  def verification_notification(respondent, password)
    @respondent = respondent
    @password = password
    mail(to: @respondent.email, subject: "Your Emergency Respondent Account is Verified")
  end
end
