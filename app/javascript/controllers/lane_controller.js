import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element.querySelector("ul"), {
      group: "board",
      ghostClass: "opacity-0",
      chosenClass: "rotate-2",
      dragClass: "rotate-2", // doesn't seem to work
      draggable: ".task",
      onEnd: this.updateTask,
      animation: 225,
      delay: 225,
      delayOnTouchOnly: true,
      touchStartThreshold: 5,
      handle: ".handle",
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  updateTask(event) {
    const form = event.item.querySelector("form");
    const laneIdInput = form.querySelector('input[name="task[lane_id]"]');
    const positionInput = form.querySelector('input[name="task[position]"]');

    const newLaneId = event.item.closest("turbo-frame").dataset.laneId;
    const newPosition = event.newIndex - 1; // -1 because sortable starts at 1 not 0

    laneIdInput.value = newLaneId;
    positionInput.value = newPosition;

    form.requestSubmit();
    event.item.classList.add("pointer-events-none");
  }

  toggleNewTaskForm({ target }) {
    let lane = target.closest("turbo-frame")
    let newTaskForm = lane.querySelector("#new_task_form_" + lane.id)
    let newTaskButton = lane.querySelector("#new_task_button_" + lane.id)

    if (newTaskForm.hidden) {
      newTaskForm.hidden = false;
      newTaskForm.querySelector("input[required]").focus();
      newTaskButton.innerText = "close";
    } else {
      newTaskForm.hidden = true;
      newTaskButton.innerText = "add";
    }
  }
}
