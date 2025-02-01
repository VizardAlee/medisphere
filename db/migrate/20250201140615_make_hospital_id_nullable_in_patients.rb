class MakeHospitalIdNullableInPatients < ActiveRecord::Migration[7.2]
  def change
    change_column_null :patients, :hospital_id, true
  end
end
