class AddDescriptionToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :description, :string
  end
end
