# app/controllers/patients/sessions_controller.rb
class Patients::SessionsController < Devise::SessionsController

  skip_before_action :authenticate_patient!, only: [:new, :create, :destroy]

  def new
    @patient = Patient.new
  end

  def create
    phone = params[:patient][:phone]

    # Look up the patient by phone
    @patient = Patient.find_by(phone: phone)

    if @patient
      # Devise helper to sign in the patient
      sign_in(@patient)
      redirect_to patient_path(@patient), notice: "Logged in successfully."
    else
      flash[:alert] = "Phone number not found."
      @patient = Patient.new
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_patient)
    redirect_to root_path, notice: "You have logged out."
  end

  private

  def after_sign_in_path_for(resource)
    patient_path(resource)  # Redirect to the patient's show page
  end
end
