class AddStaffRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :staff_role, :string
  end
end
