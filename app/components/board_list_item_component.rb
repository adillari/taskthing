class BoardListItemComponent < ApplicationComponent
  with_collection_parameter :board

  def initialize(board:)
    @board = board
  end
end
