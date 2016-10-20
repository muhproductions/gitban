class Filter < ApplicationRecord
  belongs_to :column

  Filter.inheritance_column = '_type'

  TYPES = ['namespace', 'project', 'title']
end
