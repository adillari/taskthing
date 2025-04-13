class Task < ApplicationRecord
  include Tasks::Positions
  include Tasks::Broadcasts

  belongs_to :lane
  has_one :board, through: :lane
  default_scope { order(:position) }
end
