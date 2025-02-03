class AddPhotoUrlToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :photo_url, :string
  end
end
