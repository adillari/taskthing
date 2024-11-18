class BoardComponent < ApplicationComponent
  def initialize(board:)
    @board = board
    @lanes = board.lanes
  end
end
