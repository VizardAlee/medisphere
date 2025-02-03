class AddQualificationAndExperienceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :qualification, :string
    add_column :users, :years_of_experience, :integer
  end
end
