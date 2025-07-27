require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    it "returns http success" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end

    it "shows registration form" do
      get new_user_path
      expect(response.body).to include("Sign up")
    end
  end

  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          email_address: "test@example.com",
          password: "password123"
        }
      }
    end

    it "creates a new user" do
      expect {
        post users_path, params: valid_params
      }.to change(User, :count).by(1)
    end

    it "normalizes email address" do
      post users_path, params: {
        user: {
          email_address: "  TEST@EXAMPLE.COM  ",
          password: "password123"
        }
      }
      expect(User.last.email_address).to eq("test@example.com")
    end

    it "redirects to boards on success" do
      post users_path, params: valid_params
      expect(response).to redirect_to(boards_path)
    end

    it "starts a session for the new user" do
      post users_path, params: valid_params
      user = User.last
      expect(user.sessions.count).to eq(1)
    end

    it "renders new form on validation error" do
      post users_path, params: {
        user: {
          email_address: "",
          password: "short"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Sign up")
    end

    it "rejects duplicate email addresses" do
      create(:user, email_address: "test@example.com")
      post users_path, params: valid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects short passwords" do
      post users_path, params: {
        user: {
          email_address: "test@example.com",
          password: "123"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects invalid email formats" do
      post users_path, params: {
        user: {
          email_address: "invalid-email",
          password: "password123"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:board1) { create(:board) }
    let(:board2) { create(:board) }
    let(:board_user1) { create(:board_user, user: user, board: board1, position: 1) }
    let(:board_user2) { create(:board_user, user: user, board: board2, position: 0) }

    before do
      sign_in_as(user)
      board_user1
      board_user2
    end

    it "updates board positions" do
      patch user_path(user), params: {
        user: {
          board_users_attributes: {
            "0" => { id: board_user1.id, position: 0 },
            "1" => { id: board_user2.id, position: 1 }
          }
        }
      }
      
      expect(board_user1.reload.position).to eq(0)
      expect(board_user2.reload.position).to eq(1)
    end

    it "returns http success" do
      patch user_path(user), params: {
        user: {
          board_users_attributes: {
            "0" => { id: board_user1.id, position: 0 }
          }
        }
      }
      expect(response).to have_http_status(:success)
    end
  end

  describe "rate limiting" do
    it "limits registration attempts" do
      11.times do |i|
        post users_path, params: {
          user: {
            email_address: "test#{i}@example.com",
            password: "password123"
          }
        }
      end
      
      expect(response).to redirect_to(new_user_path)
      expect(flash[:alert]).to include("Try again later")
    end
  end

  describe "authentication" do
    it "allows unauthenticated access to new and create" do
      get new_user_path
      expect(response).to have_http_status(:success)

      post users_path, params: {
        user: {
          email_address: "test@example.com",
          password: "password123"
        }
      }
      expect(response).to have_http_status(:redirect)
    end

    it "requires authentication for update" do
      user = create(:user)
      patch user_path(user), params: { user: {} }
      expect(response).to redirect_to(new_session_path)
    end
  end
end
