module Task
  class Component < Application::Component
    def initialize(task:)
      super
      @task = task
    end

    def form # submitted every time task is dropped
      form_with(model: @task) do |form|
        form.hidden_field(:lane_id, id: nil) # id attribute is nil because rails created duplicate dom id's otherwise
        form.hidden_field(:position, id: nil) # and that botthers me because its not considered valid html
      end
    end

    def title
      @task.title
    end

    def description
      if @task.description.present?
        tag.p(@task.description, class: "h-full mt-1.5 grow")
      end
    end

    def edit_button
      link_to(
        "edit",
        edit_task_path(@task),
        class: "material-symbols-outlined text-yellow-500 my-auto",
        data: { turbo_frame: :modal },
      )
    end

    def delete_button
      link_to(
        "delete",
        delete_confirmation_task_path(@task),
        class: "material-symbols-outlined text-red-500 my-auto",
        data: { turbo_frame: :modal },
      )
    end
  end
end
