require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }
  let(:board) { create(:board) }
  let(:lane) { create(:lane, board: board) }
  
  before do
    create(:board_user, user: user, board: board, role: "admin")
    sign_in_as(user)
    # Set Current.session for model callbacks during factory creation
    Current.session = user.sessions.last
  end
  
  let(:task) { create(:task, lane: lane) }

  describe "POST /tasks" do
    let(:valid_params) do
      {
        task: {
          lane_id: lane.id,
          title: "New Task",
          description: "Task description"
        }
      }
    end

    it "creates a new task" do
      expect {
        post tasks_path, params: valid_params
      }.to change(Task, :count).by(1)
    end

    it "creates task with correct attributes" do
      post tasks_path, params: valid_params
      task = Task.last
      expect(task.title).to eq("New Task")
      expect(task.description).to eq("Task description")
      expect(task.lane).to eq(lane)
    end

    it "returns http success" do
      post tasks_path, params: valid_params
      expect(response).to have_http_status(:success)
    end

    it "rejects task for lane user doesn't have access to" do
      other_lane = create(:lane)
      post tasks_path, params: {
        task: {
          lane_id: other_lane.id,
          title: "New Task"
        }
      }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /tasks/:id/edit" do
    it "returns http success" do
      get edit_task_path(task)
      expect(response).to have_http_status(:success)
    end

    it "shows edit form" do
      get edit_task_path(task)
      expect(response.body).to include(task.title)
    end

    it "returns 404 for task user doesn't have access to" do
      other_task = create(:task)
      get edit_task_path(other_task)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /tasks/:id" do
    let(:update_params) do
      {
        task: {
          title: "Updated Task",
          description: "Updated description"
        }
      }
    end

    it "updates the task" do
      patch task_path(task), params: update_params
      task.reload
      expect(task.title).to eq("Updated Task")
      expect(task.description).to eq("Updated description")
    end

    it "returns http success" do
      patch task_path(task), params: update_params
      expect(response).to have_http_status(:success)
    end

    it "can update position" do
      patch task_path(task), params: {
        task: { position: 5 }
      }
      expect(task.reload.position).to eq(5)
    end

    it "returns 404 for task user doesn't have access to" do
      other_task = create(:task)
      patch task_path(other_task), params: update_params
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /tasks/:id/delete_confirmation" do
    it "returns http success" do
      get delete_confirmation_task_path(task)
      expect(response).to have_http_status(:success)
    end

    it "returns 404 for task user doesn't have access to" do
      other_task = create(:task)
      get delete_confirmation_task_path(other_task)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /tasks/:id" do
    it "deletes the task" do
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end

    it "returns http success" do
      delete task_path(task)
      expect(response).to have_http_status(:success)
    end

    it "returns 404 for task user doesn't have access to" do
      other_task = create(:task)
      delete task_path(other_task)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "authentication" do
    before { sign_out }

    it "redirects to login for unauthenticated users" do
      get edit_task_path(task)
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "authorization" do
    it "only allows access to user's own tasks" do
      other_user = create(:user)
      other_board = create(:board)
      other_lane = create(:lane, board: other_board)
      other_task = create(:task, lane: other_lane)
      create(:board_user, user: other_user, board: other_board)

      get edit_task_path(other_task)
      expect(response).to have_http_status(:not_found)
    end
  end
end
