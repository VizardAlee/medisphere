class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_profile, if: -> { current_user&.admin? } 

  def index
    @user = current_user
    @organization = @user.organization
    @staff_members = @organization.users.where.not(id: @user.id)
    @records = @user.health_records || []
  end
end
# Compare this snippet from app/controllers/application_controller.rb: