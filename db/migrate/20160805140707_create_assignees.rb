class CreateAssignees < ActiveRecord::Migration[5.0]
  def change
    create_table :assignees do |t|
      t.string :name
      t.string :username

      t.timestamps
    end
  end
end
