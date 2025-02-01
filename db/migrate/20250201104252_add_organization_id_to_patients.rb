class AddOrganizationIdToPatients < ActiveRecord::Migration[7.2]
  def change
    add_reference :patients, :organization, null: false, foreign_key: true
  end
end
