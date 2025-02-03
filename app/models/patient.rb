class Patient < ApplicationRecord
  belongs_to :organization, optional: true

  belongs_to :hospital, optional: true

  has_many :health_records
  # validates :organization, presence: true

  belongs_to :hospital, optional: true

  validates :name, :phone, :email, presence: true
  validates :phone, uniqueness: true
  validates :email, uniqueness: true

  # Example validations for new fields
  validates :blood_type, inclusion: { in: %w[A B AB O], message: "%{value} is not a valid blood type" }, allow_blank: true
  validates :emergency_contact_phone, format: { with: /\A\d{10,15}\z/, message: "must be a valid phone number" }, allow_blank: true
end
