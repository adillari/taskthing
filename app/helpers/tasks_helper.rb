module TasksHelper
  # Form for existing Task that gets submitted when its picked up and dropped anywhere on the board
  def task_form(task)
    form_with(model: task) do |form|
      safe_join([
        form.hidden_field(:lane_id, id: nil), # id attributes are nil because rails created duplicate dom id's otherwise
        form.hidden_field(:position, id: nil), # and that botthers me because its not considered valid html
      ])
    end
  end

  def task_edit_button(task)
    link_to(
      "edit",
      edit_task_path(task),
      class: "material-symbols-outlined text-yellow-500 my-auto",
      data: { turbo_frame: :modal },
    )
  end

  def task_delete_button(task)
    link_to(
      "delete",
      delete_confirmation_task_path(task),
      class: "material-symbols-outlined text-red-500 my-auto",
      data: { turbo_frame: :modal },
    )
  end

  def task_description(task)
    if task.description.present?
      tag.p(task.description, class: "h-full border-t border-zinc-700 mt-1.5 pt-1.5 grow")
    end
  end

  def task_classes
    "bg-zinc-950 border-2 border-zinc-700 border-l-4 border-l-violet-700 rounded shadow-lg"
  end
end
