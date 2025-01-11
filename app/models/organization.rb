class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :patients, -> { where(role: :patient) }, class_name: "User"
  has_many :staff, -> { where(role: :staff) }, class_name: "User"
  validates :name, :address, :phone, presence: true
end
