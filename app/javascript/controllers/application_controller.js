import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  showSpinner() {
    document.getElementById("modal").innerHTML =
      '<div class="lds-ring flex items-center"><div></div><div></div><div></div><div></div></div>'
  }

  removeModal() {
    this.modalTarget.remove()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
