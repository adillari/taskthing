module Broadcasts
  module Board
    extend ActiveSupport::Concern

    included do
      after_commit :update_board
    end

    private

    def update_board
      return unless board
      return unless (preloaded_board = ::Board.includes(lanes: [:tasks]).find_by(id: board.id))

      broadcast_replace_to(
        board,
        target: :board,
        renderable: BoardComponent.new(board: preloaded_board),
      )
    end
  end
end
