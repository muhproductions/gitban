class AddProjectLink < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :link, :string
  end
end
