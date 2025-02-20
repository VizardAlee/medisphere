class AddPasswordDigestToPatients < ActiveRecord::Migration[7.2]
  def change
    add_column :patients, :password_digest, :string
  end
end
