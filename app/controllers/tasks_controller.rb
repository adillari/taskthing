class TasksController < ApplicationController
  before_action :set_task, except: :create

  def create
    @lane = Current.user.lanes.find(task_params[:lane_id])
    @task = @lane.tasks.create!(task_params)
  end

  def edit
  end

  def update
    @task.update!(task_params)
  end

  def delete_confirmation
  end

  def destroy
    @task.destroy!
  end

  private

  def set_task
    @task = Current.user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:lane_id, :title, :description, :position)
  end
end
