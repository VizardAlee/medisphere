class HealthRecordOrganization < ApplicationRecord
  belongs_to :health_record
  belongs_to :organization
end