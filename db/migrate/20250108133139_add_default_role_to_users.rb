class AddDefaultRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :role, 'visitor'
  end
end
