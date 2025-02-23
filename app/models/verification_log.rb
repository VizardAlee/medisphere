class VerificationLog < ApplicationRecord
  belongs_to :user
  belongs_to :respondent
end
