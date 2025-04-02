# app/models/organization.rb
class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :patients
  has_many :health_record_organizations, dependent: :destroy
  has_many :health_records, through: :health_record_organizations
  belongs_to :parent, class_name: "Organization", optional: true
  has_many :divisions, class_name: "Organization", foreign_key: "parent_id"

  scope :emergency_organizations, -> { where(organization_type: "emergency", parent_id: nil) }
  scope :divisions, -> { where.not(parent_id: nil) }
  has_many :staff, -> { where(role: :staff) }, class_name: "User"

  # Remove enum and add validation
  validates :organization_type, inclusion: { in: %w[hospital pharmacy emergency], message: "%{value} is not a valid organization type" }, presence: true
  validates :name, :address, :phone, presence: true, uniqueness: true
end