import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { class: String };

  toggle() {
    this.element.classList.toggle(this.classValue);
  }
}
