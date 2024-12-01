module Board
  class Component < Application::Component
    def initialize(board:)
      super
      @board = board
      @lanes = board.lanes
    end

    def lanes
      render(Lane::Component.with_collection(@lanes))
    end
  end
end
