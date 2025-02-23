class EmergencyAccessLog < ApplicationRecord
  belongs_to :user
  belongs_to :patient

  validates :accessed_at, presence: true
end
