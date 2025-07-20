class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to(new_user_path, alert: "Try again later.")
  }

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for(user)
      redirect_to(boards_path)
    else
      @user = user
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    Current.user.update(board_users_params)
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password)
  end

  def board_users_params
    assign_board_positions
    params.require(:user).permit(board_users_attributes: [:id, :position])
  end

  def assign_board_positions
    params[:user][:board_users_attributes].keys.each_with_index do |board, position|
      params[:user][:board_users_attributes][board][:position] = position
    end
  end
end
