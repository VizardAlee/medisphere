class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.2]
  def up
    # Remove the default value
    change_column_default :users, :role, from: "admin", to: nil

    # Change the column type to integer
    change_column :users, :role, :integer, using: 'CASE role WHEN \'admin\' THEN 0 WHEN \'staff\' THEN 1 WHEN \'patient\' THEN 2 WHEN \'visitor\' THEN 3 ELSE NULL END'

    # Add the new default value
    change_column_default :users, :role, from: nil, to: 0
  end

  def down
    # Revert the default value
    change_column_default :users, :role, from: 0, to: "admin"

    # Change the column type back to string
    change_column :users, :role, :string, using: 'CASE role WHEN 0 THEN \'admin\' WHEN 1 THEN \'staff\' WHEN 2 THEN \'patient\' WHEN 3 THEN \'visitor\' ELSE NULL END'
  end
end
