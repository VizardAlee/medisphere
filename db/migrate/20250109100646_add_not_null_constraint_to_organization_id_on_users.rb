class AddNotNullConstraintToOrganizationIdOnUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :organization_id, false
  end
end
