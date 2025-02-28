class AddEmergencyOrganizationTypeToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :emergency_organization_type, :string
  end
end
