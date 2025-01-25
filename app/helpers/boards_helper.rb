module BoardsHelper
  def boards_list(boards)
    form_with(
      url: board_users_path,
      class: "flex flex-col gap-2",
      data: { controller: :sortable, sortable_submit_value: :true },
    ) do
      safe_join([
        safe_join(
          boards.map do |board|
            tag.li(
              board.title,
              class: "bg-zinc-900 rounded-lg shadow-xl w-full items-center select-none cursor-pointer p-4",
              onclick: "Turbo.visit('#{board_path(board)}')", # I don't wanna talk about this onclick
            )
          end,
        ),
        link_to(
          t("+_new_board"),
          new_board_path,
          class: "text-violet-700 hover:underline shadow mx-auto sm:mr-auto sm:ml-1",
          data: { turbo_frame: :modal },
        ),
      ])
    end
  end

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
