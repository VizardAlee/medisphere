class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, confirmation: true, allow_blank: true
  before_validation :set_default_role, on: :create
  before_validation :downcase_email
  enum :role, { admin: 0, staff: 1, patient: 2, visitor: 3 }
  validates :role, presence: true

  # Enum for staff roles
  scope :staff, -> { where(role: :staff) }

  enum :staff_role, { doctor: 0, pharmacist: 1, nurse: 2, clerk: 3 }, prefix: :staff

  # Staff roles (only relevant for users with role: :staff)
  validates :staff_role, presence: true, if: :staff? # Require staff_role for staff users

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
