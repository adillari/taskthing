module BoardsHelper
  def board_invite_button(board)
    link_to(
      new_invite_path(board_id: board.id),
      class: "button-outlined text-green-500 border-green-500 flex items-center justify-center gap-1",
      data: { turbo_frame: :modal },
    ) do
      safe_join([
        tag.span(t("invite_friend")),
        tag.span("group_add", class: "material-symbols-outlined"),
      ])
    end
  end

  def board_edit_button(board)
    link_to(
      edit_board_path(board),
      class: "button-outlined text-yellow-500 border-yellow-500 flex items-center justify-center gap-1",
      data: { turbo_frame: :modal },
    ) do
      safe_join([
        tag.span(t("edit_title")),
        tag.span(t("edit"), class: "material-symbols-outlined"),
      ])
    end
  end

  def board_archive_unarchive_button(board_user)
    path = board_users_path
    args = {
      class: "button-outlined flex items-center justify-center gap-1 w-full",
      method: "patch",
      params: {
        id: board_user.id,
        board_id: board_user.board_id,
        archived: !board_user.archived?,
      },
    }

    if board_user.archived?
      translation = t("unarchive_board")
      icon = "unarchive"
    else
      translation = t("archive_board")
      icon = "archive"
    end

    text_and_icon = safe_join([
      tag.span(translation),
      tag.span(icon, class: "material-symbols-outlined"),
    ])

    button_to(path, **args) { text_and_icon }
  end

  def board_delete_button(board)
    link_to(
      delete_confirmation_board_path(board),
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
