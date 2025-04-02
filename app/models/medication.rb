class Medication < ApplicationRecord
  belongs_to :health_record
  has_one :patient, through: :health_record

  validates :name, :start_date, presence: true
  before_save :set_end_date

  def active?
    Time.current.between?(start_date, end_date || (start_date + duration_days.days))
  end

  private

  def set_end_date
    self.end_date = start_date + duration_days.days if duration_days.present?
  end
end
