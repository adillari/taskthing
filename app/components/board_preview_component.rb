class BoardPreviewComponent < ApplicationComponent
  with_collection_parameter :board

  def initialize(board:)
    super
    @board = board
  end

  def link_to_board
    link_to(board_path(id: @board.id), class: "p-4 grow") do
      tag.span(class: "overflow-hidden") do
        @board.title
      end
    end
  end
end
