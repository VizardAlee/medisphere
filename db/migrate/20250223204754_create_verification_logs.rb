class CreateVerificationLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :verification_logs do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :respondent, null: false, foreign_key: { to_table: :users }
      t.datetime :verified_at

      t.timestamps
    end
  end
end
