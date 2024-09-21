import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["newTaskForm"]

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: "board",
      animation: 150,
      onEnd: this.handleEnd.bind(this),
      ghostClass: "opacity-0",
      chosenClass: "rotate-2",
      dragClass: "rotate-2",
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  handleEnd(event) {
    console.log("Dragged item", event.item);
    console.log("New position", event.newIndex);
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
