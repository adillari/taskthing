class TasksController < ApplicationController
  before_action :set_task, except: :create
  before_action :set_lane, only: [:create, :destroy]

  def create
    @lane.tasks.create!(task_params)
  rescue
    head(:unprocessable_entity)
  end

  def edit
  end

  def update
    @task.update!(task_params)
    if task_params[:title] || task_params[:description]
      set_lane
      render(:create)
    end
  rescue
    head(:unprocessable_entity)
  end

  def delete_confirmation
  end

  def destroy
    @task.destroy!
    render(:create)
  end

  private

  def set_task
    @task = Current.user.tasks.find(params[:id])
  end

  def set_lane
    return @lane = @task.lane if @task

    @lane = Current.user.lanes.find_by(
      id: params.dig(:task, :lane_id),
      board_id: params.dig(:task, :board_id),
    )
  end

  def task_params
    params.require(:task).permit(:lane_id, :title, :description, :position)
  end
end
