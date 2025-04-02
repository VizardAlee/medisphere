class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, confirmation: true, allow_blank: true
  before_validation :set_default_role, on: :create
  before_validation :downcase_email

  enum :role, { admin: 0, staff: 1, patient: 2, visitor: 3, emergency_admin: 4, super_admin: 5 }
  validates :role, presence: true

  has_one_attached :photo
  attr_accessor :login

  # Enum for staff roles
  scope :staff, -> { where(role: :staff) }
  enum :staff_role, { doctor: 0, pharmacist: 1, nurse: 2, clerk: 3, emergency_respondent: 4 }, prefix: :staff

  validates :staff_role, presence: true, if: :staff?

  scope :emergency_staff, -> { where(staff_role: :emergency_respondent) }

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, uniqueness: true

  belongs_to :organization, optional: true
  has_many :health_records, dependent: :destroy
  has_many :emergency_access_logs, dependent: :destroy

  # Emergency Respondent Verification
  scope :verified_emergency_respondents, -> { where(role: :staff, staff_role: :emergency_respondent, verified: true) }

  def can_access_emergency_records?
    emergency_respondent? && verified?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)

    Rails.logger.info("Login attempt with: #{login}")

    if login.present?
      user = where(conditions)
        .where(["lower(email) = :value OR phone = :value", { value: login.downcase }])
        .first
      Rails.logger.info("User found: #{user.inspect}")
      user
    else
      where(conditions).first
    end
  end

  def super_admin?
    role == "super_admin"
  end

  def active_for_authentication?
    super && (!emergency_respondent? || verified?)
  end

  def emergency_respondent?
    role == "staff" && staff_role == "emergency_respondent"
  end

  validates :state, presence: true, if: :super_admin?
  validates :emergency_organization_type, presence: true, if: :super_admin?

  # Ensure super admins are unique per state and organization
  validates :state, uniqueness: { scope: :emergency_organization_type, message: "already has a super admin for this organization" }, if: :super_admin?

  # Override Devise password validation for unverified emergency respondents
  def password_required?
    return false if emergency_respondent? && !verified?
    super
  end

  private

  def set_default_role
    self.role ||= "visitor" # Prevents auto-assignment of emergency_respondent
  end

  def downcase_email
    self.email = email.to_s.downcase.strip
  end
end