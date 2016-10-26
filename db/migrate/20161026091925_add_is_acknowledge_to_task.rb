class AddIsAcknowledgeToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :is_acknowledged, :boolean
  end
end
