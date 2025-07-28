class BoardUsersController < ApplicationController
  def update # This is hit from the board settings page via archive or promote/demote
    @board = Current.user.boards.find(params[:board_id])
    @board_users = @board.board_users
    @board_user_to_update = @board_users.find_by(id: params[:id].to_i)
    @current_board_user = @board_users.find_by(user_id: Current.user.id)

    return if board_user_params[:role] && !@current_board_user.admin?

    @board_user_to_update.update!(board_user_params)
  end

  private

  def board_user_params
    params.permit(:role, :archived)
  end
end
