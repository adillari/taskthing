import { Controller } from "@hotwired/stimulus";

var scrollState = {}; // Of all the ways to store this information, this is the most performant.

export default class extends Controller {
  static targets = ["lane"];

  connect() {
    this.#applyScrollState();

    this.bindedRefreshBoard = this.#refreshBoard.bind(this);
    this.bindedSaveScrollState = this.#saveScrollState.bind(this);

    addEventListener("visibilitychange", this.bindedRefreshBoard);
    document.addEventListener("turbo:frame-render", this.#applyScrollState)
    document.addEventListener("turbo:before-stream-render", this.bindedSaveScrollState);
  }

  disconnect() {
    removeEventListener("visibilitychange", this.bindedRefreshBoard);
    document.removeEventListener("turbo:frame-render", this.#applyScrollState)
    document.removeEventListener("turbo:before-stream-render", this.bindedSaveScrollState);
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

  #refreshBoard() {
    if (document.visibilityState === "visible") {
      this.#saveScrollState();
      Turbo.visit(location.pathname, { frame: "board" });
    }
  }

  #saveScrollState() {
    this.laneTargets.forEach(lane => {
      scrollState[lane.id] = lane.scrollTop
    });;
  }

  #applyScrollState(event) {
    if (event && event.target.id !== "board") return;
    this.laneTargets.forEach(lane => {
      lane.scrollTop = scrollState[lane.id]
    });;
  }
}
