class BoardPreviewComponent < ApplicationComponent
  with_collection_parameter :board

  def initialize(board:)
    super
    @board = board
  end

  def link_to_board
    button_to(board_path(id: @board.id), method: :get, class: "p-4 w-full", form_class: "w-full") do
      tag.span(class: "overflow-hidden") do
        @board.title
      end
    end
  end
end
