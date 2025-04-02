class CreateMedications < ActiveRecord::Migration[7.2]
  def change
    create_table :medications do |t|
      t.references :health_record, null: false, foreign_key: true
      t.string :name, null: false
      t.string :dosage
      t.integer :duration_days # Days the medication is active
      t.datetime :start_date, null: false
      t.datetime :end_date # Calculated as start_date + duration_days
      t.timestamps
    end

    remove_column :health_records, :prescription, :text
    add_column :health_records, :notes, :text # Optional: for additional notes
  end
end
