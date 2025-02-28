class AddStateAndEmergencyOrganizationTypeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :state, :string
    add_column :users, :emergency_organization_type, :string
  end
end
