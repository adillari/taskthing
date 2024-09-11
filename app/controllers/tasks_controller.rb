class TasksController < ApplicationController
  def create
    @lane = lane

    unless @lane.tasks.create(task_params)
      render status: :unprocessable_entity
    end
  end

private

  def lane
    Current.user.lanes.find_by(
      id: params.dig(:task, :lane_id),
      board_id: params.dig(:task, :board_id)
    )
  end

  def task_params
    params.require(:task).permit(:lane_id, :title, :description)
  end
end
