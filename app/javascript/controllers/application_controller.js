import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    document.addEventListener('turbo:submit-start', this.removeModal.bind(this))
  }

  disconnect() {
    document.removeEventListener('turbo:submit-start', this.removeModal.bind(this))
  }

  removeModal() {
    this.hasModalTarget && this.modalTarget.remove()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
