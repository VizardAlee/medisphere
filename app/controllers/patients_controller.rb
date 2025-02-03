class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_staff!
  before_action :set_patient, only: %i[show edit update destroy]

  def new
    @patient = Patient.new
  end

  def show
    authorize @patient  # Ensure proper authorization based on your policy

    # If you're displaying additional details like health records, you can retrieve them here
    @health_records = @patient.health_records.includes(:staff)
  end

  def edit
    authorize @patient
    render :edit
  end

  def update
    authorize @patient

    if @patient.update(patient_params)
      redirect_to @patient, notice: "Patient was successfully updated."
    else
      render :edit,  alert: "Failed to update patient."
    end
  end

  def destroy
    authorize @patient
    @patient.destroy
    redirect_to patients_path, notice: "Patient was successfully deleted."
  end

  def create
    @patient = Patient.new(patient_params)
    # @patient.role = :patient
    @patient.organization_id = current_user.organization_id

    if @patient.save
      redirect_to dashboard_path, notice: "Patient successfully added."
    else
      render :new, alert: "Failed to add patient."
    end
  end

  def index
    @patients = Patient.all.includes(:health_records)
    @records = HealthRecord.includes(:patient).all

    respond_to do |format|
      format.html  # Renders the index.html.erb by default
      format.json  # Can render JSON if needed
    end
  end

  private

  def patient_params
    params.require(:patient).permit(
      :name, :phone, :email, :age, :gender,
      :blood_type, :allergies, :chronic_conditions, :current_medications,
      :immunization_records, :family_medical_history,
      :emergency_contact_name, :emergency_contact_relationship, :emergency_contact_phone,
      :insurance_provider, :insurance_policy_number, :organ_donor_status,
      :address, :photo_url, :last_visit_date, :registration_date
    )
  end

  def authorize_staff!
    redirect_to root_path, alert: "Unauthorized access." unless current_user.staff?
  end

  def set_patient
    @patient = Patient.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to patients_path, alert: 'Patient not found.'
  end
end
