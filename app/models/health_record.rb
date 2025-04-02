class HealthRecord < ApplicationRecord
  belongs_to :staff, class_name: "User", foreign_key: "updated_by", optional: true
  belongs_to :patient

  has_many :medications, dependent: :destroy

  after_save :update_patient_medications

  has_many :health_record_organizations, dependent: :destroy
  has_many :organizations, through: :health_record_organizations

  accepts_nested_attributes_for :medications, allow_destroy: true, reject_if: :all_blank
  
  private

  def update_patient_medications
    active_meds = patient.health_records
                         .flat_map(&:medications)
                         .select(&:active?)
                         .map { |m| "#{m.name} (#{m.dosage})" }
                         .uniq
    patient.update(current_medications: active_meds.join(", "))
  end
end
