class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :patients

  belongs_to :parent, class_name: "Organization", optional: true
  has_many :sub_organizations, class_name: "Organization", foreign_key: "parent_id"

  scope :emergency_organizations, -> { where(organization_type: "emergency", parent_id: nil) }
  scope :divisions, -> { where.not(parent_id: nil) }

  has_many :staff, -> { where(role: :staff) }, class_name: "User"
  enum organization_type: { hospital: "hospital", pharmacy: "pharmacy", emergency: "emergency" }
  validates :name, :address, :phone, presence: true, uniqueness: true
end
