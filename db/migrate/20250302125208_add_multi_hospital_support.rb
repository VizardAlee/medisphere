class AddMultiHospitalSupport < ActiveRecord::Migration[7.2]
  def change
    create_table :health_record_organizations do |t|
      t.references :health_record, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.timestamps
    end
  end
end
