module Tasks
  module Positions
    extend ActiveSupport::Concern

    included do
      before_save :adjust_positions
      before_destroy :slash_elders

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
        # Need to check lane still exists here incase we're here bc of the board's dependent destroy callbacks
        return unless (lane = Current.user.lanes.find_by(id: lane_id))

        lane.tasks
          .where("position > ?", position)
          .update_all("position = position - 1")
      end

      def slash_previous_elders
        Current.user.lanes.find(lane_id_was).tasks
          .where("position > ?", position_was)
          .update_all("position = position - 1")
      end
    end
  end
end
