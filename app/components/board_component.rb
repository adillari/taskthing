class BoardComponent < ApplicationComponent
  def initialize(board:)
    super
    @board = board
    @lanes = board.lanes
  end
end
