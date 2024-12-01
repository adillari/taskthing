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

  def edit_button
    link_to(
      "edit",
      edit_board_path(@board),
      class: "material-symbols-outlined ml-auto text-yellow-500 m-1",
      data: { turbo_frame: :modal },
    )
  end

  def delete_button
    # link_to(
    #   "delete",
    #   delete_confirmation_board_path(@board),
    #   class: "material-symbols-outlined ml-auto text-red-500",
    #   data: { turbo_frame: :modal },
    # )
  end
end
