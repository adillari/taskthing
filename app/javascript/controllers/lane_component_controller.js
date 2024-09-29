import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["newTaskForm"]

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: "board",
      animation: 225,
      onEnd: this.updateTask,
      draggable: ".task",
      handle: ".handle",
      ghostClass: "opacity-0",
      chosenClass: "rotate-2",
      dragClass: "rotate-2", // doesn't seem to work
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  updateTask(event) {
    const form = event.item.querySelector("form")
    const laneIdInput = form.querySelector('input[name="task[lane_id]"]')
    const positionInput = form.querySelector('input[name="task[position]"]')

    const newLaneId = event.item.parentElement.dataset.laneId
    const newPosition = event.newIndex - 2

    laneIdInput.value = newLaneId
    positionInput.value = newPosition

    form.requestSubmit()
  }

  toggleNewTaskForm({ target }) {
    if (this.newTaskFormTarget.hidden) {
      this.newTaskFormTarget.hidden = false
      this.newTaskFormTarget.querySelector("input[required]").focus()
      target.innerText = "close"
    } else {
      this.newTaskFormTarget.hidden = true
      target.innerText = "add"
    }
  }
}
