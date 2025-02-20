module Patients
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    private

    # Permit extra fields for sign-up
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        :name,
        :phone,
        :age,
        :gender,
        :blood_type,
        :allergies,
        :chronic_conditions,
        :current_medications,
        :immunization_records,
        :family_medical_history,
        :emergency_contact_name,
        :emergency_contact_relationship,
        :emergency_contact_phone,
        :insurance_provider,
        :insurance_policy_number,
        :organ_donor_status,
        :address,
        :photo_url,
        :last_visit_date,
        :registration_date
      ])
    end

    # Permit extra fields for account update (if you want patients to edit them)
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [
        :name,
        :phone,
        :age,
        :gender,
        :blood_type,
        :allergies,
        :chronic_conditions,
        :current_medications,
        :immunization_records,
        :family_medical_history,
        :emergency_contact_name,
        :emergency_contact_relationship,
        :emergency_contact_phone,
        :insurance_provider,
        :insurance_policy_number,
        :organ_donor_status,
        :address,
        :photo_url,
        :last_visit_date,
        :registration_date
      ])
    end
  end
end
