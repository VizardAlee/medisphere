class HealthRecord < ApplicationRecord
  belongs_to :staff, class_name: "User", foreign_key: "staff_id", optional: true
  belongs_to :patient, class_name: "User", foreign_key: "patient_id"

  validates :description, :diagnosis, :treatment_plan, presence: true
end
