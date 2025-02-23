class AddAppealStatusToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :appeal_status, :string
    add_column :organizations, :appeal_reason, :text
  end
end
