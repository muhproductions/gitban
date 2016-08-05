class Task < ApplicationRecord
  belongs_to :milestone, optional: true
  belongs_to :assignee, optional: true
  belongs_to :project, optional: true
  belongs_to :column, optional: true

  before_save :resort

  serialize :labels

  default_scope { order(:position) }

  private

  def resort
    if position_changed?
      Task.transaction do
        self.column.tasks.each_with_index do |task, i|
          next if task.id == self.id
          i += 1 if i >= self.position
          task.update_column :position, i
        end
        if column_id_changed?
          Task.transaction do
            Column.find(changed_attributes[:column_id]).tasks.each_with_index do |task, i|
              next if task.id == self.id
              task.update_column :position, i
            end
          end
        end
      end
    end
  end
end
