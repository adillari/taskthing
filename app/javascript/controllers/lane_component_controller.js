import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["newTaskForm"]

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      onEnd: this.handleEnd.bind(this),
    });
    console.log(this.sortable)
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
