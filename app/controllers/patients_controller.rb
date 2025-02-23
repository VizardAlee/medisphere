class PatientsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  before_action :authorize_staff!,   except: [:show]

  def new
    @patient = Patient.new
  end

  def show
    if user_signed_in? && current_user.staff?
      unless @patient.organization_id == current_user.organization_id
        redirect_to root_path, alert: "Unauthorized (different org)."
        return
      end
      # Staff is authorized => continue to show
      @health_records = @patient.health_records
      return
    end

    if patient_signed_in?
      # Only allow if current_patient == the @patient
      if current_patient.id != @patient.id
        redirect_to root_path, alert: "Unauthorized (not your patient record)."
      else
        @health_records = @patient.health_records
      end
      return
    end

    # -- 3) If neither staff nor correct patient => not authorized
    redirect_to new_patient_session_path, alert: "Please log in as staff or the correct patient."
  end

  def edit
    authorize @patient
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
    @patient.organization_id = current_user.organization_id

    temporary_password = SecureRandom.hex(8)
    @patient.password = temporary_password
    @patient.password_confirmation =  temporary_password

    if @patient.save
      PatientMailer.with(patient: @patient, temporary_password: temporary_password).send_login_details.deliver_later if @patient.email.present?

      flash[:notice] = "Patient successfully added. Login details sent to the patient."
      redirect_to dashboard_path
    else
      render :new, alert: "Failed to add patient."
    end
  end

  def index
    @patients = current_user.organization.patients.includes(:health_records)
    @records = HealthRecord.includes(:patient).where(patients: { organization_id: current_user.organization_id })

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
      :address, :photo, :last_visit_date, :registration_date, :national_identity_number,
      :voter_id
    )
  end

  def authorize_staff!
    unless user_signed_in? && current_user.staff?
      redirect_to root_path, alert: "Unauthorized access."
    end
  end

  def set_patient
    @patient = Patient.find_by(id: params[:id])
    if @patient.nil?
      redirect_to patients_path, alert: "Patient not found."
    end
  end

  def authorize_patient_show!
    return if user_signed_in? && current_user.staff?

    # else must be a logged-in patient looking at themselves
    if patient_signed_in?
      # Ensure the patient is viewing their own profile
      return if current_patient.present? && current_patient.id == params[:id].to_i
    end

    redirect_to root_path, alert: "Unauthorized"
  end
end
