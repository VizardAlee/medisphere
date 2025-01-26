class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_profile, if: -> { current_user&.admin? }

  def index
    if current_user.admin?
      # Fetch staff and patients for the admin's organization
      @staffs = current_user.organization&.users&.where(role: :staff) || []
      @patients = current_user.organization&.patients || []
    elsif current_user.staff?
      # Fetch health records assigned to the current staff
      @records = HealthRecord.where(user_id: current_user.id) # Corrected from staff_id to user_id
    elsif current_user.patient?
      # Fetch health records belonging to the patient
      @records = HealthRecord.where(patient_id: current_user.id)
    else
      # Default for visitors (if applicable)
      @visitors = User.where(role: :visitor)
    end
  end
end
