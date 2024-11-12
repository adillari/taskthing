import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "indicator"];

  connect() {
    addEventListener("focus", this.#focusWindow);
    addEventListener("blur", this.#blurWindow);
    document.addEventListener(
      "turbo:submit-start",
      this.removeModal.bind(this),
    );
    document.addEventListener(
      "turbo:before-fetch-request",
      this.#showSpinner.bind(this),
    );
    document.addEventListener(
      "turbo:before-fetch-response",
      this.#hideSpinner.bind(this),
    );
  }

  disconnect() {
    removeEventListener("focus", this.#focusWindow);
    removeEventListener("blur", this.#blurWindow);
    document.removeEventListener(
      "turbo:submit-start",
      this.removeModal.bind(this),
    );
    document.removeEventListener(
      "turbo:before-fetch-request",
      this.#showSpinner.bind(this),
    );
    document.removeEventListener(
      "turbo:before-fetch-response",
      this.#hideSpinner.bind(this),
    );
  }

  removeModal() {
    this.hasModalTarget && this.modalTarget.remove();
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  // private

  #blurWindow() {
    if (document.getElementById("board")) {
      document.body.classList.add("opacity-50");
    }
  }

  #focusWindow() {
    if (document.getElementById("board")) {
      Turbo.visit(location.pathname, { frame: "board" });
      document.body.classList.remove("opacity-50");
    }
  }

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
