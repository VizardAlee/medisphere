class AddApprovedToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :approved, :boolean
  end
end
