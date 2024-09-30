class Task < ApplicationRecord
  belongs_to :lane
  has_one :board, through: :lane
  default_scope { order(:position) }
  before_save :adjust_positions

private

  def bump_elders
    Current.user.lanes.find(lane_id).tasks
      .where("position >= ?", position)
      .update_all("position = position + 1")
  end

  def slash_previous_elders
    Current.user.lanes.find(lane_id_was).tasks
      .where("position > ?", position_was)
      .update_all("position = position - 1")
  end

  def slash_hopped
    Current.user.lanes.find(lane_id).tasks
      .where("position > ? and position <= ?", position_was, position)
      .update_all("position = position - 1")
  end

  def bump_hopped
    Current.user.lanes.find(lane_id).tasks
      .where("position < ? AND position >= ?", position_was, position)
      .update_all("position = position + 1")
  end

  def adjust_positions
    return unless lane_changed? || position_changed?
    return bump_elders if new_record?

    if lane_id_changed?
      slash_previous_elders
      bump_elders
    else
      if position_grew?
        slash_hopped
      else
        bump_hopped
      end
    end
  end

  def position_grew?
    position > position_was
  end
end
