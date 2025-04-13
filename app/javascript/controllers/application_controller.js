import { Controller } from "@hotwired/stimulus";

// This basically holds the application wide javascript behavior for:
// - modal functionality
// - header loading spinner
export default class extends Controller {
  static targets = ["modal", "indicator"];

  connect() {
    this.bindedRemoveModal = this.removeModal.bind(this);
    this.bindedShowSpinner = this.#showSpinner.bind(this);
    this.bindedHideSpinner = this.#hideSpinner.bind(this);

    document.addEventListener("turbo:submit-start", this.bindedRemoveModal);
    document.addEventListener(
      "turbo:before-fetch-request",
      this.bindedShowSpinner,
    );
    document.addEventListener(
      "turbo:before-fetch-response",
      this.bindedHideSpinner,
    );
  }

  disconnect() {
    document.removeEventListener("turbo:submit-start", this.bindedRemoveModal);
    document.removeEventListener(
      "turbo:before-fetch-request",
      this.bindedShowSpinner,
    );
    document.removeEventListener(
      "turbo:before-fetch-response",
      this.bindedHideSpinner,
    );
  }

  removeModal() {
    this.hasModalTarget && this.modalTarget.remove();
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  // private

  #showSpinner(event) {
    if (this.#isPrefetchRequest(event)) return;
    this.hasIndicatorTarget && (this.indicatorTarget.hidden = false);
  }

  #hideSpinner() {
    this.hasIndicatorTarget && (this.indicatorTarget.hidden = true);
  }

  #isPrefetchRequest(event) {
    return event.detail.fetchOptions.headers["X-Sec-Purpose"] === "prefetch";
  }
}
