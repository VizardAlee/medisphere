class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_default_role, on: :create
  enum role: { admin: 0, staff: 1, patient: 2, visitor: 3 }
  validates :role, presence: true

  # enum for staff roles

  ROLES = %w[doctor pharmacist nurse clerk]
  validates :name, presence: true
  validates :staff_role, inclusion: { in: ROLES }, allow_nil: true

  belongs_to :organization, optional: true
  has_many :health_records, dependent: :destroy

  private

  def set_default_role
    self.role ||= "admin"
    Rails.logger.info("Default role set to #{self.role}") if self.role_was.nil?
  end
end
