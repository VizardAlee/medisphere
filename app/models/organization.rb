class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  validates :name, :address, :phone, presence: true
end
