import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  static targets = ["newTaskForm"];

  connect() {
    this.sortable = Sortable.create(this.element, {
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

    const newLaneId = event.item.parentElement.dataset.laneId;
    const newPosition = event.newIndex - 1; // -1 because sortable starts at 1 not 0

    laneIdInput.value = newLaneId;
    positionInput.value = newPosition;

    form.requestSubmit();
    event.item.classList.add("pointer-events-none");
  }

  removeTurboPermanent() {
    if (this.newTaskFormTarget.querySelector("form").checkValidity()) {
      this.element.querySelectorAll("[data-turbo-permanent]").forEach((el) => {
        el.removeAttribute("data-turbo-permanent");
      });
    }
  }
}
