class AddReportedToEmergencyAccessLogs < ActiveRecord::Migration[7.2]
  def change
    add_column :emergency_access_logs, :reported, :boolean, default: false, null: false
  end
end
