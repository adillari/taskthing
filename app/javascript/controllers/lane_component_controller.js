import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["newTaskForm"]

  toggleNewTaskForm({ target }) {
    if (this.newTaskFormTarget.hidden) {
      this.newTaskFormTarget.hidden = false
      this.newTaskFormTarget.querySelector("input").focus()
      target.innerText = "close"
    } else {
      this.newTaskFormTarget.hidden = true
      target.innerText = "add"
    }
  }
}
