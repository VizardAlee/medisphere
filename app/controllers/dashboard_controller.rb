class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_profile, if: -> { current_user&.admin? }

  def index
    if current_user.admin?
      # Fetch staff and patients for the admin's organization
      @staffs = current_user.organization&.users&.where(role: :staff) || []
      @patients = current_user.organization&.patients || []
      @records = HealthRecord.includes(:patient).where(patients: { organization_id: current_user.organization_id }) # Ensure records are available
    elsif current_user.staff?
      # Fetch health records assigned to the current staff
      @patients = current_user.organization&.patients || [] # Ensures @patients is never nil
      @records = HealthRecord.joins(:patient).where(patients: { organization_id: current_user.organization_id })
    elsif current_user.patient?
      # Fetch health records belonging to the patient
      @records = HealthRecord.where(patient_id: current_user.id)
      @patients = Patient.none
    else
      # Default for visitors (if applicable)
      @visitors = User.where(role: :visitor)
      @patients = Patient.none
      @records = HealthRecord.none
    end
  end
end
