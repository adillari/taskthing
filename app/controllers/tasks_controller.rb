class TasksController < ApplicationController
  before_action :set_lane
  before_action :set_task, except: :create

  def create
    @lane.tasks.create!(task_params)
  rescue
    render status: :unprocessable_entity
  end

  def delete_confirmation
  end

  def destroy
    @task.destroy!
    redirect_to board_path
  end

private

  def task
    @task = lane.tasks.find(params[:id])
  end

  def lane
    @lane = Current.user.lanes.find_by(
      id: params.dig(:task, :lane_id),
      board_id: params.dig(:task, :board_id)
    )
  end

  def task_params
    params.require(:task).permit(:lane_id, :title, :description)
  end
end
