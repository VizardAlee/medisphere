class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_default_role, on: :create
  before_validation :downcase_email
  enum role: [:admin, :staff, :patient, :visitor]
  validates :role, presence: true

  # Enum for staff roles
  ROLES = %w[doctor pharmacist nurse clerk]
  validates :name, presence: true
  validates :staff_role, inclusion: { in: ROLES }, allow_nil: true

  # Add validation for uniqueness of email across all users, excluding the current user
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :organization, optional: true
  has_many :health_records, dependent: :destroy

  private

  def set_default_role
    self.role ||= "admin"
    Rails.logger.info("Default role set to #{self.role}") if self.role_was.nil?
  end

  def downcase_email
    self.email = email.to_s.downcase.strip
  end
end
