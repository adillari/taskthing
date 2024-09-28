class Task < ApplicationRecord
  belongs_to :lane
  has_one :board, through: :lane
  default_scope { order(:position) }
  before_save :bump_siblings, if: :new_record?

private

  def bump_siblings
    lane.tasks.update_all("position = position + 1")
  end
end
