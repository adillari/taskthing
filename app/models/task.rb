class Task < ApplicationRecord
  belongs_to :lane
  has_one :board, through: :lane
end
