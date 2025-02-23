class AddParentToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :parent_id, :bigint
    add_foreign_key :organizations, :organizations, column: :parent_id
    add_index :organizations, :parent_id
  end
end
