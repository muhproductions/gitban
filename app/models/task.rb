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
  rescue
    false
  end

  def done?
    self.column.name == 'Done'
  rescue
    false
  end

  def link
    "#{self.project.link}/issues/#{self.gitlab_internal_id.gsub('#','')}"
  end

end
