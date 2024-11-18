import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "indicator"];

  connect() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    this.firefoxOnLinux = /Firefox/.test(navigator.userAgent) && /Linux/.test(navigator.userAgent) && !/Mobile/.test(navigator.userAgent);

    this.onDragStart = () => this.dragging = true;
    this.bindedFocusWindow = this.#focusWindow.bind(this);
    this.bindedBlurWindow = this.#blurWindow.bind(this);
    this.bindedRemoveModal = this.removeModal.bind(this);
    this.bindedShowSpinner = this.#showSpinner.bind(this);
    this.bindedHideSpinner = this.#hideSpinner.bind(this);

    document.addEventListener('dragstart', this.onDragStart);
    addEventListener("focus", this.bindedFocusWindow);
    addEventListener("blur", this.bindedBlurWindow);
    document.addEventListener("turbo:submit-start", this.bindedRemoveModal);
    document.addEventListener("turbo:before-fetch-request", this.bindedShowSpinner);
    document.addEventListener("turbo:before-fetch-response", this.bindedHideSpinner);
  }

  disconnect() {
    document.removeEventListener('dragstart', this.onDragStart);
    removeEventListener("focus", this.bindedFocusWindow);
    removeEventListener("blur", this.bindedBlurWindow);
    document.removeEventListener("turbo:submit-start", this.bindedRemoveModal);
    document.removeEventListener("turbo:before-fetch-request", this.bindedShowSpinner);
    document.removeEventListener("turbo:before-fetch-response", this.bindedHideSpinner);
  }

  removeModal() {
    this.hasModalTarget && this.modalTarget.remove();
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  // private

  #blurWindow() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    if (this.firefoxOnLinux && this.dragging) return;

    if (document.getElementById("board")) {
      document.body.classList.add("opacity-50");
    }
  }

  #focusWindow() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    if (this.firefoxOnLinux && this.dragging) return (this.dragging = false);

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
