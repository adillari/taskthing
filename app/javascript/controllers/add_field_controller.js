import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fake"];

  connect() {
    this.fakeTarget.classList.add("fake");
    this.fakeTarget
      .querySelectorAll("input")
      .forEach((input) => (input.disabled = true));
  }

  reveal() {
    const copy = this.fakeTarget.cloneNode(true);
    copy.hidden = false;
    copy.querySelectorAll("input").forEach((input) => (input.disabled = false));

    this.fakeTarget.before(copy);
  }

  remove({ target }) {
    target.closest(".fake").remove();
  }
}
