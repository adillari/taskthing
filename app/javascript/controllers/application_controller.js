import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "indicator"];

  connect() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    this.firefoxOnLinux = // TODO: move this stuff to board js controller
      /Firefox/.test(navigator.userAgent) &&
      /Linux/.test(navigator.userAgent) &&
      !/Mobile/.test(navigator.userAgent);

    this.onDragStart = () => (this.dragging = true); // TODO: move this stuff to board js controller
    this.bindedFocusWindow = this.#focusWindow.bind(this); // TODO: move this stuff to board js controller
    this.bindedBlurWindow = this.#blurWindow.bind(this); // TODO: move this stuff to board js controller

    this.bindedRemoveModal = this.removeModal.bind(this);
    this.bindedShowSpinner = this.#showSpinner.bind(this);
    this.bindedHideSpinner = this.#hideSpinner.bind(this);

    document.addEventListener("dragstart", this.onDragStart); // TODO: move this stuff to board js controller
    addEventListener("focus", this.bindedFocusWindow); // TODO: move this stuff to board js controller
    addEventListener("blur", this.bindedBlurWindow); // TODO: move this stuff to board js controller
  
    document.addEventListener("turbo:submit-start", this.bindedRemoveModal);
    document.addEventListener("turbo:before-fetch-request", this.bindedShowSpinner);
    document.addEventListener("turbo:before-fetch-response", this.bindedHideSpinner);
  }

  disconnect() {
    document.removeEventListener("dragstart", this.onDragStart); // TODO: move this stuff to board js controller
    removeEventListener("focus", this.bindedFocusWindow); // TODO: move this stuff to board js controller
    removeEventListener("blur", this.bindedBlurWindow); // TODO: move this stuff to board js controller

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

  #blurWindow() { // TODO: move this stuff to board js controller
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    if (this.firefoxOnLinux && this.dragging) return;

    if (document.getElementById("board")) {
      document.body.classList.add("opacity-50");
    }
  }

  #focusWindow() { // TODO: move this stuff to board js controller
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
