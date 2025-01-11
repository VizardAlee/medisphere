class PatientsController < ApplicationController
  before_action :authenticate_user!

  def new
    @patient = User.new
  end

  def create
    @patient = User.new(patient_params)
    @patient.role = :patient
    @patient.organization = current_user.organization

    if @patient.save
      redirect_to dashboard_path, notice: "Patient successfully added."
    else
      render :new
    end
  end

  private

  def patient_params
    params.require(:user).permit(:name, :email, :phone_number, :address)
  end
end
