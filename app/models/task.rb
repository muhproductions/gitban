class Task < ApplicationRecord
  belongs_to :milestone, optional: true
  belongs_to :assignee, optional: true
  belongs_to :project, optional: true
  belongs_to :column, optional: true

  self.inheritance_column = :_type_disabled

  serialize :labels

  default_scope { order(:position) }

  def in_progress?
    !!['Testing', 'In Progress'].include?(self.column.name)
  end

  def done?
    self.column.name == 'Done'
  end

end
