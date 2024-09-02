class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_path, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for user
      redirect_to boards_path
    else
      @errors = user.errors
      render :new
    end
  end

private

  def user_params
    params.require(:user).permit(:email_address, :password)
  end
end
