class AddDetailsToPatients < ActiveRecord::Migration[7.2]
  def change
    change_table :patients do |t|
      # Medical Information
      t.string  :blood_type
      t.text    :allergies
      t.text    :chronic_conditions
      t.text    :current_medications
      t.text    :immunization_records
      t.text    :family_medical_history

      # Emergency Contact Information
      t.string  :emergency_contact_name
      t.string  :emergency_contact_relationship
      t.string  :emergency_contact_phone
      t.string  :insurance_provider
      t.string  :insurance_policy_number
      t.boolean :organ_donor_status, default: false

      # Administrative & Additional Fields
      t.string  :address
      t.string  :photo_url
      t.datetime :last_visit_date
      t.datetime :registration_date
    end
  end
end
