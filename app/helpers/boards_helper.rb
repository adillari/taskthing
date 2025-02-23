module BoardsHelper
  def boards_list(board_users)
    form_with(
      model: Current.user,
      class: "flex flex-col gap-2",
      data: { controller: :sortable, sortable_submit_value: true },
    ) do |form|
      safe_join([
        form.fields_for(:board_users, board_users) do |board_user_form|
          tag.li(
            class: "bg-zinc-900 rounded-lg shadow-xl flex items-center select-none cursor-pointer p-4",
            onclick: "Turbo.visit('#{board_path(board_user_form.object.board.id)}')",
          ) do
            safe_join([
              board_user_form.object.board.title,
              board_user_form.hidden_field(:id),
              board_user_form.hidden_field(:position),
              shared(board_user_form.object.board),
            ])
          end
        end,
        link_to(
          t("+_new_board"),
          new_board_path,
          class: "text-violet-700 hover:underline shadow mx-auto sm:mr-auto sm:ml-1",
          data: { turbo_frame: :modal },
        ),
      ])
    end
  end

  def shared(board)
    tag.span("(shared)", class: "opacity-50 ml-auto") if board.board_users.many?
  end

  def board_invite_button
    link_to(
      new_invite_path(board_id: @board.id),
      class: "button-outlined text-green-500 border-green-500 flex items-center justify-center gap-1",
      data: { turbo_frame: :modal },
    ) do
      safe_join([
        tag.span(t("invite_friend")),
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
        tag.span(t("edit_title")),
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
        tag.span(t("delete_board")),
        tag.span("delete", class: "material-symbols-outlined"),
      ])
    end
  end

  def lane_field_attrs(fake)
    if fake
      { data: { add_field_target: "fake" }, hidden: true }
    else
      { data: { controller: "toggle-class", toggle_class_class_value: "opacity-50" } }
    end.merge(class: "flex items-center justify-center gap-2 mb-2")
  end

  def delete_lane_action(fake)
    if fake
      "click->add-field#remove"
    else
      "click->toggle-class#toggle"
    end
  end
end
