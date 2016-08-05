class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :milestone, foreign_key: true
      t.references :assignee, foreign_key: true
      t.string :title
      t.string :link
      t.integer :gitlabid
      t.references :project, foreign_key: true
      t.string :state
      t.text :labels
      t.date :due_date
      t.integer :position
      t.references :column, foreign_key: true

      t.timestamps
    end
  end
end
