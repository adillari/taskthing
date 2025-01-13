module BoardsHelper
  def board_invite_button
    link_to(
      new_invite_path(board_id: @board.id),
      class: "button-outlined text-green-500 border-green-500 flex items-center justify-center gap-1",
      data: { turbo_frame: :modal },
    ) do
      safe_join([
        tag.span("Invite Friend"),
        tag.span("group_add", class: "material-symbols-outlined"),
      ])
    end
  end

  def board_edit_button
    link_to(
      edit_board_path(@board),
      class: "button-outlined text-yellow-500 border-yellow-500 flex items-center justify-center gap-1",
      data: { turbo_frame: :modal },
    ) do
      safe_join([
        tag.span("Edit Title"),
        tag.span("edit", class: "material-symbols-outlined"),
      ])
    end
  end

  def board_delete_button
    link_to(
      delete_confirmation_board_path(@board),
      class: "button-outlined text-red-500 border-red-500 flex items-center justify-center gap-1",
      data: { turbo_frame: :modal },
    ) do
      safe_join([
        tag.span("Delete Board"),
        tag.span("delete", class: "material-symbols-outlined"),
      ])
    end
  end
end
