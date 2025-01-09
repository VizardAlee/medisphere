class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    if current_user.patient?
      @records = HealthRecord.where(patient_id: current_user.id)
    elsif current_user.admin? || current_user.staff?
      @records = HealthRecord.all
    else
      @records = []
    end
  end
end
