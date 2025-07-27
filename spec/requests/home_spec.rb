require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when user is authenticated" do
      let(:user) { create(:user) }

      before do
        sign_in_as(user)
      end

      it "redirects to boards path" do
        get root_path
        expect(response).to redirect_to(boards_path)
      end
    end

    context "when user is not authenticated" do
      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "shows home page" do
        get root_path
        expect(response.body).to include("Taskthing")
      end
    end

    context "with valid session cookie" do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      it "redirects to boards path" do
        # Simulate having a valid session cookie
        allow_any_instance_of(ApplicationController).to receive(:resume_session).and_return(true)
        
        get root_path
        expect(response).to redirect_to(boards_path)
      end
    end
  end

  describe "authentication" do
    it "allows unauthenticated access" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
