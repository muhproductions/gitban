class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :avatar_url, :string
    add_column :users, :username, :string
  end
end
