class CreateEmergencyAccessLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :emergency_access_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.datetime :accessed_at

      t.timestamps
    end
  end
end
