require "rails_helper"

RSpec.describe "Invites", type: :request do
  let(:user) { create(:user) }
  let(:board) { create(:board) }
  let(:invite) { create(:invite, user: user, board: board) }

  before do
    create(:board_user, user: user, board: board, role: "admin")
    sign_in_as(user)
  end

  describe "GET /invites/new" do
    it "creates a new invite" do
      expect {
        get new_invite_path(board_id: board.id)
      }.to change(Invite, :count).by(1)
    end

    it "returns http success" do
      get new_invite_path(board_id: board.id)
      expect(response).to have_http_status(:success)
    end

    it "associates invite with current user and board" do
      get new_invite_path(board_id: board.id)
      invite = Invite.last
      expect(invite.user).to eq(user)
      expect(invite.board).to eq(board)
    end
  end

  describe "POST /invites" do
    let(:valid_params) do
      {
        invite: {
          email_address: "invite@example.com",
          board_id: board.id
        }
      }
    end

    it "creates an invite" do
      expect {
        post invites_path, params: valid_params
      }.to change(Invite, :count).by(1)
    end

    it "creates invite with correct attributes" do
      post invites_path, params: valid_params
      invite = Invite.last
      expect(invite.email_address).to eq("invite@example.com")
      expect(invite.board).to eq(board)
      expect(invite.user).to eq(user)
    end

    it "returns http success" do
      post invites_path, params: valid_params
      expect(response).to have_http_status(:success)
    end

    it "prevents self-invitation" do
      post invites_path, params: {
        invite: {
          email_address: user.email_address,
          board_id: board.id
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "sends invitation email" do
      expect {
        post invites_path, params: valid_params
      }.to have_enqueued_mail(BoardsMailer, :invite)
    end
  end

  describe "GET /invites/:id" do
    let(:signed_invite) { Invite.find_signed(invite.to_sgid.to_s) }

    it "returns http success" do
      get invite_path(signed_invite)
      expect(response).to have_http_status(:success)
    end

    it "shows invite details" do
      get invite_path(signed_invite)
      expect(response.body).to include(board.title)
    end

    it "returns 404 for invalid signed id" do
      get invite_path("invalid-signed-id")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /invites/:id" do
    let(:invited_user) { create(:user, email_address: "invited@example.com") }

    before do
      sign_in_as(invited_user)
    end

    context "when accepting invite" do
      it "creates board_user association" do
        expect {
          patch invite_path(invite), params: { commit: "Accept" }
        }.to change(BoardUser, :count).by(1)
      end

      it "creates board_user with member role" do
        patch invite_path(invite), params: { commit: "Accept" }
        board_user = BoardUser.last
        expect(board_user.user).to eq(invited_user)
        expect(board_user.board).to eq(board)
        expect(board_user.role).to eq("member")
      end

      it "destroys the invite" do
        expect {
          patch invite_path(invite), params: { commit: "Accept" }
        }.to change(Invite, :count).by(-1)
      end

      it "redirects to board" do
        patch invite_path(invite), params: { commit: "Accept" }
        expect(response).to redirect_to(board_path(board))
      end
    end

    context "when rejecting invite" do
      it "destroys the invite" do
        expect {
          patch invite_path(invite), params: { commit: "Reject" }
        }.to change(Invite, :count).by(-1)
      end

      it "redirects to root" do
        patch invite_path(invite), params: { commit: "Reject" }
        expect(response).to redirect_to(root_path)
      end

      it "does not create board_user association" do
        expect {
          patch invite_path(invite), params: { commit: "Reject" }
        }.not_to change(BoardUser, :count)
      end
    end

    context "with invalid commit parameter" do
      it "destroys the invite" do
        expect {
          patch invite_path(invite), params: { commit: "Invalid" }
        }.to change(Invite, :count).by(-1)
      end

      it "redirects to root" do
        patch invite_path(invite), params: { commit: "Invalid" }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "authentication" do
    before { sign_out }

    it "redirects to login for unauthenticated users" do
      get new_invite_path(board_id: board.id)
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "authorization" do
    it "only allows board admins to create invites" do
      member_user = create(:user)
      create(:board_user, user: member_user, board: board, role: "member")
      sign_in_as(member_user)

      get new_invite_path(board_id: board.id)
      expect(response).to have_http_status(:not_found)
    end
  end
end
