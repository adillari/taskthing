class Lane < ApplicationRecord
  has_many :tasks
  belongs_to :board
  default_scope { order(:position) }
end
