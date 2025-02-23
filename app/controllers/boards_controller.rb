class BoardsController < ApplicationController
  layout -> { false if turbo_frame_request? } # only comes into play for Turbo.visit to update board on window refocus

  def index
    @board_users = board_users
  end

  def show
    @board = boards.includes(lanes: [:tasks]).find(params[:id])
  end

  def new
    @board = Board.new
  end

  def create
    board = Board.new(board_params)
    board.board_users.new(user: Current.user, role: "admin")

    if board.save
      redirect_to(boards_path)
    else
      @errors = board.errors
      render(:new)
    end
  end

  def edit
    @board = boards.find(params[:id])
  end

  def update
    @board = boards.find(params[:id])
    @board.update(board_params)
    redirect_to(board_settings_path(@board))
  end

  def delete_confirmation
    @board = boards.find(params[:id])
  end

  def destroy
    board = boards.find(params[:id])

    board.destroy!
    redirect_to(boards_path)
  end

  private

  def boards
    Current.user.boards.order(:position)
  end

  def board_users
    Current.user.board_users.order(:position).includes(:board)
  end

  def board_params
    assign_lane_positions if params[:board][:lanes_attributes]
    params.require(:board).permit(:title, lanes_attributes: [:id, :name, :position, :_destroy])
  end

  def assign_lane_positions
    params[:board][:lanes_attributes].keys.each_with_index do |lane, position|
      params[:board][:lanes_attributes][lane][:position] = position
    end
  end
end
