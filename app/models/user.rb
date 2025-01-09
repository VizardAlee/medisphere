class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_default_role, on: :create
  enum :role, %i[admin staff patient emergency_respondent]
  validates :role, presence: true

  has_many :health_records, dependent: :destroy

  private

  def set_default_role
    self.role ||= "patient"
  end
end
