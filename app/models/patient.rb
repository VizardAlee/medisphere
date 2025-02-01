class Patient < ApplicationRecord
  belongs_to :organization, optional: true

  has_many :health_records
  # validates :organization, presence: true
end
