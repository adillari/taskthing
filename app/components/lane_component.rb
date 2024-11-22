class LaneComponent < ApplicationComponent
  def initialize(lane:)
    super
    @lane = lane
    @task = lane.tasks.new
    @tasks = lane.tasks.all
  end
end
