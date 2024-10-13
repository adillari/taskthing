class BoardsController < ApplicationController
  def index
    @boards = boards
  end

  def show
    @board = boards.includes(lanes: [ :tasks ]).find(params[:id])
  end

  def new
    @board = boards.new
  end

  def create
    board = boards.new(board_params)

    if board.save
      redirect_to boards_path
    else
      @errors = board.errors
      render :new
    end
  end

  def edit
    @board = Current.user.boards.find(params[:id])
  end

  def update
    @board = Current.user.boards.find(params[:id])
    @board.update(board_params)
    redirect_to boards_path
  end

  def delete_confirmation
    @board = boards.find(params[:id])
  end

  def destroy
    board = boards.find(params[:id])
    board.destroy!
    redirect_to boards_path
  end

private

  def boards
    Current.user.boards
  end

  def board_params
    params.require(:board).permit(:title)
  end
end
