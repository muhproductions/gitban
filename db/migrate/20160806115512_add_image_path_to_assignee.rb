class AddImagePathToAssignee < ActiveRecord::Migration[5.0]
  def change
    add_column :assignees, :image_path, :string
  end
end
