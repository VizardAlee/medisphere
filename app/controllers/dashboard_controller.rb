class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_profile, if: -> { current_user&.admin? } 

  def index
    if current_user.admin?
      @staff = current_user.organization&.users&.where(role: :staff) || []
      @patients = current_user.organization&.patients || []
    elsif current_user.staff?
      @records = HealthRecord.where(staff_id: current_user.id)
    elsif current_user.patient?
      @records = HealthRecord.where(patient_id: current_user.id)
    else
      @visitors = User.where(role: :visitor)
    end
  end
end
# Compare this snippet from app/controllers/application_controller.rb: