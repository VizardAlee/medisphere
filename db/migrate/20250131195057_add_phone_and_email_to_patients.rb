class AddPhoneAndEmailToPatients < ActiveRecord::Migration[7.2]
  def change
    add_column :patients, :phone, :string, null: false
    add_column :patients, :email, :string

    add_index :patients, :phone, unique: true
    add_index :patients, :email, unique: true
  end
end
