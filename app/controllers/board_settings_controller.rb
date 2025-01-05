class BoardSettingsController < ApplicationController
  def show
    @board = Current.user.boards.find(params[:board_id])
  end
end
