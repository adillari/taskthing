class BoardComponent < ApplicationComponent
  def initialize(board:)
    super
    @board = board
    @lanes = board.lanes
  end

  def lanes
    render(LaneComponent.with_collection(@lanes))
  end
end
