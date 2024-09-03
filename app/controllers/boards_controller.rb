class BoardsController < ApplicationController
  def index
    @boards = Current.user.boards
  end

  def show
    @board = Current.user.boards.includes(:lanes).find(params[:id])
    # @board = find_board.includes(:lanes)
  end

  def new
    @board = Board.new
  end

  def create
    board = Current.user.boards.new(board_params)

    if board.save
      # TODO: turbo stream shiz
      redirect_to boards_path
    else
      @errors = board.errors
      render :new
    end
  end

  def update
  end

  def delete_confirmation
    @board = find_board
  end

  def destroy
    board = find_board
    board.destroy!
    # TODO: turbo stream shiz
    redirect_to boards_path
  end

private

  def find_board
    Current.user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title)
  end
end
