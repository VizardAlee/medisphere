class Patient < ApplicationRecord
  # ----------------------------------------------------------------------------
  # 1) Devise modules. Notice we remove `:validatable` because we don’t want 
  #    Devise to require a password or enforce password rules.
  # ----------------------------------------------------------------------------
  devise :database_authenticatable, :registerable, :recoverable,
  :rememberable, authentication_keys: [:phone]
  # ----------------------------------------------------------------------------
  # 2) Tells Devise: "We do NOT require email or password at all."
  # ----------------------------------------------------------------------------
  
  attr_accessor :login
  
  def email_required?
    false
  end

  def password_required?
    false
  end

  # ----------------------------------------------------------------------------
  # 3) Override Devise’s default `find_for_database_authentication` to look up 
  #    by `phone` only. (We remove email/username checks for pure phone login.)
  # ----------------------------------------------------------------------------
  # in app/models/patient.rb
  def self.find_for_database_authentication(warden_conditions)
    where(phone: warden_conditions[:phone]).first
  end


  def valid_password?(_password)
    true  # Always return true to bypass password authentication
  end

  # ----------------------------------------------------------------------------
  # 4) We still keep your existing validations for phone, email, etc.
  #    But if you only truly need phone for login, you can remove the 
  #    presence requirement for email or username. That's optional.
  # ----------------------------------------------------------------------------
  validates :phone, presence: true, uniqueness: true
  validates :name,  presence: true
  # email is optional now, but you can keep it if staff want to store it.
  # validates :email, uniqueness: true, allow_blank: true

  belongs_to :organization, optional: true
  belongs_to :hospital, optional: true
  has_one_attached :photo
  has_many :health_records

  # ----------------------------------------------------------------------------
  # 5) If you generate a random password on creation (for staff usage), 
  #    you can keep or remove this callback. It's optional now since 
  #    password isn't truly used for login. 
  # ----------------------------------------------------------------------------
  before_validation :set_username_and_password, on: :create

  def display_photo
    if photo.attached?
      photo.variant(resize_to_fill: [200, 200])
    else
      "default_avatar.png"
    end
  end

  private

  def set_username_and_password
    Rails.logger.info ">>> Running set_username_and_password callback <<<"

    # Example: if you want a fallback 'username' for internal reference:
    base_username = email.presence || phone
    return if base_username.blank?

    self.username = generate_unique_username(base_username)

    # Generate a random password so Devise is happy storing *something*.
    # Even though `password_required?` is false, Devise still wants a 
    # password_digest column. 
    self.password ||= SecureRandom.hex(8)
  end

  def generate_unique_username(base)
    candidate = base.parameterize(separator: "_")
    counter = 1
    while Patient.exists?(username: candidate)
      candidate = "#{base.parameterize(separator: "_")}_#{counter}"
      counter += 1
    end
    candidate
  end
end
