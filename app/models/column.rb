class Column < ApplicationRecord
  default_scope { order(:position) }

  belongs_to :board

  has_many :tasks

  validates :name, presence: true
end
