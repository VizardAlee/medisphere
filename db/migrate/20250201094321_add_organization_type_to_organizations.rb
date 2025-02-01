class AddOrganizationTypeToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :organization_type, :string, default: "hospital"
  end
end
