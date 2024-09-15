import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["newTaskForm"]
  connect() {
    console.log("Hello, Stimulus!", this.element);
  }

  toggleNewTaskForm() {
    if (this.newTaskFormTarget.hidden) {
      this.newTaskFormTarget.hidden = false
      this.newTaskFormTarget.querySelector("input").focus()
    } else {
      this.newTaskFormTarget.hidden = true
    }
  }
}
