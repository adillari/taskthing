require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, email_address: "test@example.com", password: "password123") }

  describe "GET /session/new" do
    it "returns http success" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end

    it "shows login form" do
      get new_session_path
      expect(response.body).to include("Login")
    end
  end

  describe "POST /session" do
    let(:valid_params) do
      {
        email_address: "test@example.com",
        password: "password123"
      }
    end

    it "authenticates with valid credentials" do
      user # create the user
      post session_path, params: valid_params
      expect(response).to redirect_to(root_path)
    end

    it "normalizes email address during authentication" do
      user # create the user
      post session_path, params: {
        email_address: "  TEST@EXAMPLE.COM  ",
        password: "password123"
      }
      expect(response).to redirect_to(root_path)
    end

    it "creates a session for the user" do
      user # create the user
      expect {
        post session_path, params: valid_params
      }.to change(Session, :count).by(1)
    end

    it "rejects invalid email" do
      user # create the user
      post session_path, params: {
        email_address: "wrong@example.com",
        password: "password123"
      }
      expect(response).to redirect_to(new_session_path)
      expect(flash[:alert]).to include("Try another email address or password")
    end

    it "rejects invalid password" do
      user # create the user
      post session_path, params: {
        email_address: "test@example.com",
        password: "wrongpassword"
      }
      expect(response).to redirect_to(new_session_path)
      expect(flash[:alert]).to include("Try another email address or password")
    end

    it "rejects empty credentials" do
      user # create the user
      post session_path, params: {
        email_address: "",
        password: ""
      }
      expect(response).to redirect_to(new_session_path)
      expect(flash[:alert]).to include("Try another email address or password")
    end
  end

  describe "DELETE /session" do
    it "terminates the session" do
      sign_in_as(user)
      expect {
        delete session_path
      }.to change(Session, :count).by(-1)
    end

    it "redirects to root path" do
      sign_in_as(user)
      delete session_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /session" do
    it "redirects to root path" do
      sign_in_as(user)
      get session_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "rate limiting" do
    it "limits login attempts" do
      user # create the user
      11.times do
        post session_path, params: {
          email_address: "test@example.com",
          password: "wrongpassword"
        }
      end
      
      expect(response).to redirect_to(new_session_path)
      expect(flash[:alert]).to include("Try again later")
    end
  end

  describe "authentication" do
    it "allows unauthenticated access to new and create" do
      get new_session_path
      expect(response).to have_http_status(:success)

      post session_path, params: {
        email_address: "test@example.com",
        password: "password123"
      }
      expect(response).to have_http_status(:redirect)
    end

    it "requires authentication for destroy" do
      delete session_path
      expect(response).to redirect_to(new_session_path)
    end
  end
end 