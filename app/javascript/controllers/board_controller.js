import { Controller } from "@hotwired/stimulus";

var scrollState = {}; // Of all the ways to store this information, this is the most performant.

export default class extends Controller {
  static targets = ["lane"];

  connect() {
    this.bindedFetchBoard = this.#fetchBoard.bind(this);
    this.bindedUpdateBoard = this.#updateBoard.bind(this);

    addEventListener("visibilitychange", this.bindedFetchBoard);
    document.addEventListener("turbo:before-fetch-response", this.bindedUpdateBoard);
  }

  disconnect() {
    removeEventListener("visibilitychange", this.bindedFetchBoard);
    document.removeEventListener("turbo:before-fetch-response", this.bindedUpdateBoard);
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

  #fetchBoard() {
    if (document.visibilityState === "visible") {
      this.#saveScrollState();
      Turbo.visit(location.pathname, { frame: "board" });
    }
  }

  async #updateBoard(event) {
    if (event && event.target.id !== "board") return;

    event.preventDefault();

    const response = new DOMParser().parseFromString(
      await event.detail.fetchResponse.response.clone().text(),
      "text/html",
    );

    const newVersion = response.getElementById("version")?.innerText;
    const oldVersion = document.getElementById("version")?.innerText;

    if (newVersion !== oldVersion) {
      const newBoard = response.getElementById("board");
      const oldBoard = document.getElementById("board");

      if (newBoard && oldBoard) {
        oldBoard.innerHTML = newBoard.innerHTML;
        this.#applySaveState();
      }
    }
  }

  #saveScrollState() {
    this.laneTargets.forEach((lane) => {
      scrollState[lane.id] = lane.lastElementChild.scrollTop;
    });
  }

  #applySaveState() {
    this.laneTargets.forEach((lane) => {
      lane.lastElementChild.scrollTop = scrollState[lane.id];
    });
  }
}
