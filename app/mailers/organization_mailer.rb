class OrganizationMailer < ApplicationMailer
  def approval_email(organization)
    @organization = organization
    # Find the emergency_admin or admin user for this organization
    admin_user = @organization.users.find_by(role: ["emergency_admin", "admin"])
    if admin_user
      mail(to: admin_user.email, subject: "#{@organization.name} has been approved")
    else
      Rails.logger.warn "No admin found for organization #{@organization.id}"
      # Optionally skip sending or send to a default admin email
    end
  end

  def rejection_email(organization)
    @organization = organization
    admin_user = @organization.users.find_by(role: ["emergency_admin", "admin"])
    if admin_user
      mail(to: admin_user.email, subject: "#{@organization.name} has been rejected")
    else
      Rails.logger.warn "No admin found for organization #{@organization.id}"
    end
  end
end