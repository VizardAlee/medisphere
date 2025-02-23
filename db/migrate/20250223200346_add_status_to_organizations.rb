class AddStatusToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :status, :string, default: "pending"
  end
end
