class OrganizationMailer < ApplicationMailer
  default from: "no-reply@medisphere.com"

  def approval_email(organization)
    @organization = organization
    mail(to: @organization.admin.email, subject: "Your Division Has Been Approved!")
  end

  def rejection_email(organization)
    @organization = organization
    mail(to: @organization.admin.email, subject: "Your Division Has Been Rejected")
  end
end
