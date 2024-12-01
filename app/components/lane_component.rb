class LaneComponent < ApplicationComponent
  def initialize(lane:)
    super
    @lane = lane
    @task = lane.tasks.new
    @tasks = lane.tasks.select(&:persisted?)
  end

  def name
    @lane.name
  end

  def new_task_button_id
    dom_id(@lane, :new_task_button)
  end

  def new_task_form_id
    dom_id(@lane, :new_task_form)
  end

  def new_task_form
    form_with(model: @task) do |form|
      form.hidden_field(:board_id, value: @lane.board.id)
      form.hidden_field(:lane_id, value: @lane.id)
      form.text_field(
        :title,
        id: dom_id(@lane, :task_title),
        required: true,
        placeholder: "Title",
        autocomplete: :off,
        class: "mb-1 task-input-field",
      )
      tag.div(class: "flex") do
        form.text_area(
          :description,
          id: dom_id(@lane, :task_description),
          rows: 2,
          placeholder: "Description (optional)",
          autocomplete: :off,
          class: "resize-none task-input-field",
        )
        form.submit(
          "save",
          class: "material-symbols-outlined cursor-pointer text-violet-700 mt-auto",
          data: { action: "lane-component#removeTurboPermanent" },
        )
      end
    end
  end

  def tasks
    render(TaskComponent.with_collection(@tasks))
  end
end
