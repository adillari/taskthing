class TaskComponent < ApplicationComponent
  def initialize(task:)
    super
    @task = task
  end
end
