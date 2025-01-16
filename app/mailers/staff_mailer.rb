class StaffMailer < ApplicationMailer
  def welcome_email(staff, password)
    @staff = staff
    @password = password
    @organization = staff.organization

    mail(
      to: @staff.email,
      subject: "Welcome to #{Rails.application.credentials.dig(:app_name)}",
    )
  end
end
