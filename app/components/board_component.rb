class BoardComponent < ApplicationComponent
  def initialize(board:)
    @lanes = board.lanes
  end
end
