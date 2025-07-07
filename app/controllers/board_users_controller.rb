class BoardUsersController < ApplicationController
  def update # This is hit from the board settings page by admins editing roles
    @board = Current.user.boards.find(params[:board_id])
    @board_users = @board.board_users
    @board_user = @board_users.find_by(id: params[:id].to_i)
    @current_board_user = @board_users.find(Current.user.id)

    if @current_board_user.admin?
      @board_user.update!(role: params[:role])
    end
  end
end
