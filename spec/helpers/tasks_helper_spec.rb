require "rails_helper"

RSpec.describe(TasksHelper, type: :helper) do
  # It's very annoying to use a double here because of the many methods the form_with helper calls on the model
  let(:task) { Task.new(id: 5, position: 8, lane_id: 2, title: "Task Title", description: "Task Description") }

  describe "#task_form" do
    it "renders a form with hidden fields for lane_id and position" do
      result = helper.task_form(task)

      expect(result).to(have_css('form[method="post"][action="/tasks"][accept-charset="UTF-8"]'))
      within("form") do
        expect(result).to(have_css('input[type="hidden"][name="task[lane_id]"][value="2"]'))
        expect(result).to(have_css('input[type="hidden"][name="task[position]"][value="8"]'))
      end
    end
  end

  describe "#task_edit_button" do
    it "returns a link to edit the task" do
      result = helper.task_edit_button(task)

      expect(result).to(have_css(
        'a.material-symbols-outlined.text-yellow-500.my-auto[data-turbo-frame="modal"][href="/tasks/5/edit"]',
        text: "edit",
        exact: true,
      ))
    end
  end

  describe "#task_delete_button" do
    it "returns a link to delete confirmation for the task" do
      result = helper.task_delete_button(task)

      expect(result).to(have_css(
        'a.material-symbols-outlined.text-red-500.my-auto[data-turbo-frame="modal"][href="/tasks/5/delete_confirmation"]', # rubocop:disable Layout/LineLength
        text: "delete",
        exact: true,
      ))
    end
  end

  describe "#task_description" do
    context "when task has a description" do
      it "returns a paragraph with the task description" do
        result = helper.task_description(task)

        expect(result).to(have_css(
          "p.h-full.border-t.border-zinc-700.mt-1\\.5.pt-1\\.5.grow",
          text: "Task Description",
          exact: true,
        ))
      end
    end

    context "when task has no description" do
      it "returns nil" do
        allow(task).to(receive(:description).and_return(nil))
        result = helper.task_description(task)

        expect(result).to(be_nil)
      end
    end
  end

  describe "#task_classes" do
    it "returns the expected CSS classes" do
      expect(helper.task_classes)
        .to(eq("bg-zinc-950 border-2 border-zinc-700 border-l-4 border-l-violet-700 rounded shadow-lg"))
    end
  end
end
