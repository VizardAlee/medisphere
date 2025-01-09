class ChangeDefaultRoleToVisitor < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :role, from: "patient", to: "visitor"
  end
end
