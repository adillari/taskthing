import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  removeModal() {
    this.modalTarget.remove()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
