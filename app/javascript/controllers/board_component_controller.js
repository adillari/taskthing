import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["lane"];

  connect() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    this.firefoxOnLinux =
      /Firefox/.test(navigator.userAgent) &&
      /Linux/.test(navigator.userAgent) &&
      !/Mobile/.test(navigator.userAgent);

    this.onDragStart = () => (this.dragging = true);
    this.bindedFocusWindow = this.#focusWindow.bind(this);
    this.bindedBlurWindow = this.#blurWindow.bind(this);

    document.addEventListener("dragstart", this.onDragStart);
    addEventListener("focus", this.bindedFocusWindow);
    addEventListener("blur", this.bindedBlurWindow);
  }

  disconnect() {
    document.removeEventListener("dragstart", this.onDragStart);
    removeEventListener("focus", this.bindedFocusWindow);
    removeEventListener("blur", this.bindedBlurWindow);
  }

  toggleLane({ target }) {
    const lane = target.closest("turbo-frame");
    const laneExpanded = target.innerText === "unfold_less";

    if (laneExpanded) {
      this.laneTargets.forEach((lane) => {
        lane.hidden = false;
        target.innerText = "unfold_more";
      });
    } else {
      this.laneTargets.forEach((lane) => {
        lane.hidden = true;
      });
      lane.hidden = false;
      target.innerText = "unfold_less";
    }
  }

  // private

  #blurWindow() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    if (this.firefoxOnLinux && this.dragging) return;

    document.body.classList.add("opacity-50");
  }

  #focusWindow() {
    // For stupid bug in Firefox on Linux/X11 where dragging blurs the window.
    if (this.firefoxOnLinux && this.dragging) return (this.dragging = false);

    Turbo.visit(location.pathname, { frame: "board" });
    document.body.classList.remove("opacity-50");
  }
}
