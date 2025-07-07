module BoardUsersHelper
  def promote_demote_link(board_user)
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
      board_users_path(id: board_user.id),
      class: "underline opacity-50 cursor-pointer",
      params: { role: },
    )
  end
end
