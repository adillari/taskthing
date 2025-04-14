module TasksHelper
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

  def new_task_classes
    "#{shared_task_classes} p-2"
  end

  def task_classes
    "#{shared_task_classes} task flex cursor-grab select-none"
  end

  private

  def shared_task_classes
    "bg-zinc-950 border-2 border-zinc-700 border-l-4 border-l-violet-700 rounded shadow-lg"
  end
end
