class AddMoreToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :state, :string
    add_column :users, :token, :string
  end
end
