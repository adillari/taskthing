require "rails_helper"

RSpec.describe "Boards", type: :request do
  let(:user) { create(:user) }
  let(:board) { create(:board) }
  let(:board_user) { create(:board_user, user: user, board: board) }

  before do
    sign_in_as(user)
  end

  describe "GET /boards" do
    it "returns http success" do
      get boards_path
      expect(response).to have_http_status(:success)
    end

    it "shows user's boards" do
      board_user # create the association
      get boards_path
      expect(response.body).to include(board.title)
    end

    it "orders boards by position" do
      board2 = create(:board)
      create(:board_user, user: user, board: board2, position: 0)
      board_user.update!(position: 1)
      
      get boards_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /boards/:id" do
    it "returns http success" do
      board_user # create the association
      get board_path(board)
      expect(response).to have_http_status(:success)
    end

    it "includes lanes and tasks" do
      board_user # create the association
      lane = create(:lane, board: board)
      task = create(:task, lane: lane)
      
      get board_path(board)
      expect(response.body).to include(lane.name)
      expect(response.body).to include(task.title)
    end

    it "returns 404 for non-existent board" do
      get board_path(999999)
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for board user doesn't have access to" do
      other_board = create(:board)
      get board_path(other_board)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /boards/new" do
    it "returns http success" do
      get new_board_path
      expect(response).to have_http_status(:success)
    end

    it "shows new board form" do
      get new_board_path
      expect(response.body).to include("New Board")
    end
  end

  describe "POST /boards" do
    let(:valid_params) { { board: { title: "New Test Board" } } }

    it "creates a new board" do
      expect {
        post boards_path, params: valid_params
      }.to change(Board, :count).by(1)
    end

    it "creates board_user with admin role" do
      post boards_path, params: valid_params
      board = Board.last
      board_user = board.board_users.find_by(user: user)
      expect(board_user.role).to eq("admin")
    end

    it "redirects to boards index on success" do
      post boards_path, params: valid_params
      expect(response).to redirect_to(boards_path)
    end

    it "renders new form on validation error" do
      post boards_path, params: { board: { title: "" } }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Board")
    end
  end

  describe "GET /boards/:id/edit" do
    it "returns http success for board owner" do
      create(:board_user, user: user, board: board, role: "admin")
      get edit_board_path(board)
      expect(response).to have_http_status(:success)
    end

    it "returns 404 for non-owner" do
      board_user # create as member
      get edit_board_path(board)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /boards/:id" do
    let(:admin_board_user) { create(:board_user, user: user, board: board, role: "admin") }

    before { admin_board_user }

    it "updates board title" do
      patch board_path(board), params: { board: { title: "Updated Title" } }
      expect(board.reload.title).to eq("Updated Title")
    end

    it "redirects to board settings on success" do
      patch board_path(board), params: { board: { title: "Updated Title" } }
      expect(response).to redirect_to(board_settings_path(board))
    end

    it "renders unprocessable on error" do
      patch board_path(board), params: { board: { title: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 404 for non-owner" do
      admin_board_user.update!(role: "member")
      patch board_path(board), params: { board: { title: "Updated Title" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /boards/:id/delete_confirmation" do
    it "returns http success" do
      board_user # create the association
      get delete_confirmation_board_path(board)
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /boards/:id" do
    let(:admin_board_user) { create(:board_user, user: user, board: board, role: "admin") }

    before { admin_board_user }

    it "deletes the board" do
      expect {
        delete board_path(board)
      }.to change(Board, :count).by(-1)
    end

    it "redirects to boards index" do
      delete board_path(board)
      expect(response).to redirect_to(boards_path)
    end

    it "returns 404 for non-owner" do
      admin_board_user.update!(role: "member")
      delete board_path(board)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "authentication" do
    before { sign_out }

    it "redirects to login for unauthenticated users" do
      get boards_path
      expect(response).to redirect_to(new_session_path)
    end
  end
end
