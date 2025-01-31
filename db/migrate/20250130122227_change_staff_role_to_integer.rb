class ChangeStaffRoleToInteger < ActiveRecord::Migration[7.0]
  def up
    # 1. Add a new integer column
    add_column :users, :new_staff_role, :integer

    # 2. Define role mapping with a default for NULL/invalid values
    roles_mapping = {
      "doctor" => 0,
      "pharmacist" => 1,
      "nurse" => 2,
      "clerk" => 3
    }
    roles_mapping.default = 0 # Default to "doctor" if value is NULL or invalid

    # 3. Bulk update without validations (using SQL)
    User.where(role: :staff).find_each do |user|
      # Use `update_all` to bypass validations
      User.where(id: user.id).update_all(
        new_staff_role: roles_mapping[user.staff_role]
      )
    end

    # 4. Remove the old column
    remove_column :users, :staff_role

    # 5. Rename the new column
    rename_column :users, :new_staff_role, :staff_role
  end

  def down
    # Reverse logic (optional)
  end
end