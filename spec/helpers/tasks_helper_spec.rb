require "rails_helper"

RSpec.describe(TasksHelper, type: :helper) do
  let(:task) { Task.new(id: 5, position: 8, lane_id: 2, title: "Task Title", description: "Task Description") }

  describe "#task_edit_button" do
    it "returns a link to edit the task" do
      result = helper.task_edit_button(task)

      expect(result).to(have_css(
        'a.material-symbols-outlined.text-yellow-500.my-auto[data-turbo-frame="modal"][href="/tasks/5/edit"]',
        text: "edit",
      ))
    end
  end

  describe "#task_delete_button" do
    it "returns a link to delete confirmation for the task" do
      result = helper.task_delete_button(task)

      expect(result).to(have_css(
        'a.material-symbols-outlined.text-red-500.my-auto[data-turbo-frame="modal"][href="/tasks/5/delete_confirmation"]', # rubocop:disable Layout/LineLength
        text: "delete",
      ))
    end
  end

  describe "#new_task_classes" do
    it "returns the expected CSS classes" do
      expect(helper.new_task_classes)
        .to(eq("bg-zinc-950 border-2 border-zinc-700 border-l-4 border-l-violet-700 rounded shadow-lg p-2"))
    end
  end

  describe "#task_classes" do
    it "returns the expected CSS classes" do
      expect(helper.task_classes)
        .to(eq("bg-zinc-950 border-2 border-zinc-700 border-l-4 border-l-violet-700 rounded shadow-lg task flex cursor-grab select-none"))
    end
  end
end
