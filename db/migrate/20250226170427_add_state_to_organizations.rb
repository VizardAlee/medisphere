class AddStateToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :state, :string
  end
end
