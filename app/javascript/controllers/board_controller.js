import { Controller } from "@hotwired/stimulus";

var scrollState = {}; // Of all the ways to store this information, this is the most performant.

export default class extends Controller {
  static targets = ["lane"];

  connect() {
    this.bindedRefreshBoard = this.#refreshBoard.bind(this);

    addEventListener("visibilitychange", this.bindedRefreshBoard);
    document.addEventListener('turbo:before-fetch-response', this.#checkVersion)
  }

  disconnect() {
    removeEventListener("visibilitychange", this.bindedRefreshBoard);
    document.removeEventListener('turbo:before-fetch-response', this.#checkVersion)
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
    this.laneTargets.forEach((lane) => {
      scrollState[lane.id] = lane.lastElementChild.scrollTop;
    });
  }

  async #checkVersion(event) {
    if (event && event.target.id !== "board") return;

    event.preventDefault();

    const response = new DOMParser().parseFromString(await event.detail.fetchResponse.response.clone().text(), "text/html");

    const newVersion = response.getElementById("version")?.innerText;
    const oldVersion = document.getElementById("version")?.innerText;

    if (newVersion !== oldVersion) {
      const newBoard = response.getElementById("board");
      const oldBoard = document.getElementById("board");

      if (frame && newContent) {
        oldBoard.innerHTML = newBoard.innerHTML;
        document.querySelectorAll(".lane").forEach((lane) => {
          lane.lastElementChild.scrollTop = scrollState[lane.id];
        });
      }
    }
  }
}
