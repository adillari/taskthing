module BoardUsersHelper
  def promote_demote_button(board_user)
    return if board_user.user_id == Current.user.id

    if board_user.admin?
      text = t("demote")
      role = "member"
    else
      text = t("promote")
      role = "admin"
    end

    button_to(
      text,
      board_users_path,
      class: "underline opacity-50 cursor-pointer",
      method: "patch",
      params: {
        id: board_user.id,
        board_id: board_user.board_id,
        role:,
      },
    )
  end
end
