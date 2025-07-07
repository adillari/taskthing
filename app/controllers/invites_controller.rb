class InvitesController < ApplicationController
  def new
    @invite = Current.user.invites.create(board_id: params[:board_id])
  end

  def create
    raise if invite_params[:email_address] == Current.user.email_address # can't invite yourself duh

    invite = Current.user.invites.create(invite_params)

    BoardsMailer.invite(invite).deliver_later
  end

  def show
    @invite = Invite.find_signed(params[:id])
    @user = @invite.user
    @board = @invite.board
  end

  def update # I believe the built-in CSRF should be secure enough to not have to worry about exploits here
    @invite = Invite.find(params[:id])
    case params[:commit]
    when "Accept"
      @board = @invite.board
      @board.board_users.new(user: Current.user, role: "member")
      @board.save!
      @invite.destroy!
      redirect_to(board_path(@board))
    else
      @invite.destroy!
      redirect_to(root_path)
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email_address, :board_id)
  end
end
