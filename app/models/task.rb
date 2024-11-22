class Task < ApplicationRecord
  include Broadcasts::Board

  belongs_to :lane
  has_one :board, through: :lane
  before_save :adjust_positions
  before_destroy :slash_elders
  default_scope { order(:position) }

  private

  def adjust_positions
    return bump_elders if new_record? # new task created
    return bump_elders && slash_previous_elders if lane_id_changed? # task moved to different lane
    return unless position_changed? # nothing happened (picked and dropped in same place)

    # task moved inside same lane
    if position > position_was
      slash_hopped
    elsif position < position_was
      bump_hopped
    end
  end

  def bump_hopped
    Current.user.lanes.find(lane_id).tasks
      .where("position < ? AND position >= ?", position_was, position)
      .update_all("position = position + 1")
  end

  def slash_hopped
    Current.user.lanes.find(lane_id).tasks
      .where("position > ? and position <= ?", position_was, position)
      .update_all("position = position - 1")
  end

  def bump_elders
    Current.user.lanes.find(lane_id).tasks
      .where("position >= ?", position)
      .update_all("position = position + 1")
  end

  def slash_elders
    Current.user.lanes.find(lane_id).tasks
      .where("position > ?", position)
      .update_all("position = position - 1")
  end

  def slash_previous_elders
    Current.user.lanes.find(lane_id_was).tasks
      .where("position > ?", position_was)
      .update_all("position = position - 1")
  end
end
