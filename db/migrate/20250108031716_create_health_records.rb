class CreateHealthRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :health_records do |t|
      t.references :patient, null: false, foreign_key: true
      t.text :diagnosis
      t.text :prescription
      t.bigint :updated_by

      t.timestamps
    end
  end
end
