class HealthRecord < ApplicationRecord
  belongs_to :staff, class_name: "User", foreign_key: "updated_by", optional: true
  belongs_to :patient

  validates :prescription, :diagnosis, presence: true
end
