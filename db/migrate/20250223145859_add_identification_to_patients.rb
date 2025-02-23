class AddIdentificationToPatients < ActiveRecord::Migration[7.2]
  def change
    add_column :patients, :national_identity_number, :string
    add_column :patients, :voter_id, :string

    add_index :patients, :national_identity_number, unique: true
    add_index :patients, :voter_id, unique: true
  end
end
