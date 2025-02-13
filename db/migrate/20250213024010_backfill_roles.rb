class BackfillRoles < ActiveRecord::Migration[8.0]
  def change
    # Grab all boards that only have 1 board user
    # map those to the board_user
    # these can all be updated to 'admin'
    #
    # next we wanna grab all boards that have multiple board_users
    # then we want to order then by id or created_at ascending
    # the first ones of these should be 'admin'
    #
    # after we do this every other board_user is a member
    boards_with_one_user = Board.includes(:board_users).filter { _1.board_users.size == 1 }
    lone_board_user_ids = boards_with_one_user.flat_map(&:board_users).pluck(:id)
    BoardUser.where(id: lone_board_user_ids).update_all(role: "admin")

    boards_with_multiple_users = Board.includes(:board_users).filter { _1.board_users.size > 1 }
    boards_with_multiple_users.each do
      _1.board_users.order(:id).first.update!(role: "admin")
    end

    BoardUser.where(role: nil).update_all(role: "member")
  end
end
