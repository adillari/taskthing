module Tasks
  module Broadcasts
    extend ActiveSupport::Concern

    included do
      after_commit { board.bump_version! }
      after_create_commit :broadcast_create_to_board
      after_update_commit :broadcast_update_to_board
      after_destroy_commit :broadcast_destroy_to_board

      private

      def broadcast_create_to_board
        Turbo::StreamsChannel.broadcast_render_later_to(
          board,
          partial: "tasks/broadcasts/create",
          locals: { task: self },
        )
      end

      def broadcast_update_to_board
        Turbo::StreamsChannel.broadcast_render_later_to(
          board,
          partial: "tasks/broadcasts/update",
          locals: { task: self },
        )
      end

      def broadcast_destroy_to_board
        Turbo::StreamsChannel.broadcast_render_to(
          board,
          partial: "tasks/broadcasts/destroy",
          locals: { task: self },
        )
      end
    end
  end
end
