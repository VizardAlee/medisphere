class AddOrganizationIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :organization, foreign_key: true
  end
end
