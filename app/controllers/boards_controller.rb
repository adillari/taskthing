class BoardsController < ApplicationController
  def index
    @boards = Current.user.boards
  end

  def new
    @board = Board.new
  end

  def create
    debugger
  end

  def update
  end

  def destroy
  end
end
