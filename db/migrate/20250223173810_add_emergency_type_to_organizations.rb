class AddEmergencyTypeToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :emergency_type, :boolean, default: false
  end
end
