class HealthRecordsController < ApplicationController
  before_action :authenticate_user_or_patient!
  before_action :set_health_record, only: %i[show edit update destroy]
  before_action :authorize_health_record, only: %i[create update destroy]

  def index
    if current_user # Admin or Staff
      if current_user.admin? || current_user.staff?
        @records = policy_scope(HealthRecord)
                     .includes(:patient)
                     .where(patients: { organization_id: current_user.organization_id })
      end
    elsif current_patient # Patient
      @records = policy_scope(HealthRecord).where(patient_id: current_patient.id)
    else
      @records = HealthRecord.none
    end
  
    # Apply search filter
    if params[:search].present?
      @records = @records.joins(:patient)
                         .where("patients.name ILIKE :query OR diagnosis ILIKE :query", query: "%#{params[:search]}%")
    end
  
    authorize HealthRecord
  
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "health_records_list", locals: { records: @records } }
    end
  end
  

  def show
    # Ensure that @record is not nil before proceeding
    if @record.nil?
      redirect_to health_records_path, alert: "Record not found." and return
    end

    authorize @record
  end

  def new
    @record = HealthRecord.new
    authorize @record
    respond_to do |format|
      format.html # renders new.html.erb
      format.json { render json: @record }
    end
  end

  def create
    @record = HealthRecord.new(health_record_params)
    @record.user_id = current_user.id
    authorize @record

    if @record.save
      redirect_to @record, notice: 'Record was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @record
  end

  def update
    authorize @record
    if @record.update(health_record_params)
      redirect_to @record, notice: 'Record was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @record
    @record.destroy
    redirect_to health_records_path, notice: 'Record was successfully deleted.'
  end

  private

  def set_health_record
    @record = HealthRecord.find_by(id: params[:id])
    if @record.nil?
      Rails.logger.error "HealthRecord with ID #{params[:id]} not found."
      redirect_to health_records_path, alert: "Record not found." and return
    end
  end

  def authorize_health_record
    authorize HealthRecord
  end

  def health_record_params
    params.require(:health_record).permit(:patient_id, :diagnosis, :prescription, :updated_by)
  end
end
