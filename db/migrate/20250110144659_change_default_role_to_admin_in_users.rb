class ChangeDefaultRoleToAdminInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :role, from: 'visitor', to: 'admin'
  end
end
