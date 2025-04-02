class RespondentMailer < ApplicationMailer
  def verification_notification(respondent, temp_password)
    @respondent = respondent
    @temp_password = temp_password
    mail(to: @respondent.email, subject: "Your Account Has Been Verified")
  end
end