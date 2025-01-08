class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.references :hospital, null: false, foreign_key: true

      t.timestamps
    end
  end
end
