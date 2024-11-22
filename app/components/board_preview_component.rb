class BoardPreviewComponent < ApplicationComponent
  with_collection_parameter :board

  def initialize(board:)
    super
    @board = board
  end
end
