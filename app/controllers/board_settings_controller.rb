class BoardSettingsController < ApplicationController
  def show
    @board = Current.user.boards.find(params[:board_id])
    @board_users = @board.board_users
    @board_user = @board_users.find_by(user_id: Current.user.id)
  end
end
