class BoardsMailer < ApplicationMailer
  def invite(invite)
    @invite = invite
    mail(subject: "Invite to Collaberate on \"#{@invite.board.title}\"", to: @invite.email_address)
  end
end
