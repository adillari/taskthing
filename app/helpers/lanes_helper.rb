module LanesHelper
  def new_task_form(lane)
    form_with(model: lane.tasks.new) do |form|
      safe_join([
        form.hidden_field(:board_id, value: lane.board.id),
        form.hidden_field(:lane_id, value: lane.id),
        form.text_field(
          :title,
          id: dom_id(lane, :task_title),
          required: true,
          placeholder: "Title",
          autocomplete: :off,
          class: "mb-1 task-input-field",
        ),
        tag.div(class: "flex") do
          safe_join([
            form.text_area(
              :description,
              id: dom_id(lane, :task_description),
              rows: 2,
              placeholder: "Description (optional)",
              autocomplete: :off,
              class: "resize-none task-input-field",
            ),
            form.submit(
              "save",
              class: "material-symbols-outlined cursor-pointer text-violet-700 mt-auto",
              data: { action: "lane-component#removeTurboPermanent" },
            ),
          ])
        end,
      ])
    end
  end
end
