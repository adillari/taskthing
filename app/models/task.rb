class Task < ApplicationRecord
  belongs_to :lane
  has_one :board, through: :lane
  default_scope { order(created_at: :desc) }
end
