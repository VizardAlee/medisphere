class AddUsernameToPatients < ActiveRecord::Migration[7.2]
  def change
    add_column :patients, :username, :string
  end
end
