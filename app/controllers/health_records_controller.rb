class HealthRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_health_record, only: %i[ create update destroy ]
  
  def index
    @records = if current_user.admin? || current_user.staff?
      HealthRecord.all
    elseif current_user.patient?
      HealthRecord.where(patient_id: current_user.id)
    else
      []
    end
    authorize @records
  end
  
  def show
    @record = HealthRecord.find(params[:id])
    authorize @record
  end

  def create
    @record = HealthRecord.new(health_record_params)
    authorize @record
    if @record.save
      redirect_to @record, notice: 'Record was successfully created.'
    else
      render :new
    end
  end

  private

  def authorize_health_record
    authorize HealthRecord
  end

  def health_record_params
    params.require(:health_record).permit(:patient_id, :diagnosis, :prescription, :updated_by)
  end
end
