class InvitesController < ApplicationController
  def new
    @invite = Invite.new(board_id: params[:board_id])
  end

  def create
    raise if invite_params[:email_address] == Current.user.email_address # can't invite yourself duh

    invite = Current.user.invites.create(invite_params)

    BoardsMailer.invite(invite).deliver_later
  end

  def show
    @invite = Invite.find(params[:id])
  end

  private

  def invite_params
    params.require(:invite).permit(:email_address, :board_id)
  end
end
