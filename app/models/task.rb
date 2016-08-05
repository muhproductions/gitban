class Task < ApplicationRecord
  belongs_to :milestone, optional: true
  belongs_to :assigne, optional: true
  belongs_to :project, optional: true
  belongs_to :column, optional: true
end
