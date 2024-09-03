class Lane < ApplicationRecord
  belongs_to :board
  default_scope { order(:position) }
end
