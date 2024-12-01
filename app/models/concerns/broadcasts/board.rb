module Broadcasts
  module Board
    extend ActiveSupport::Concern

    included do
      after_commit :update_board
    end

    private

    def update_board
      broadcast_replace_to(
        board,
        target: :board,
        renderable: BoardComponent.new(board: ::Board.includes(lanes: [:tasks]).find(board.id)),
      )
    end
  end
end
