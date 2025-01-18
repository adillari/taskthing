import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      ghostClass: "opacity-0",
      // chosenClass: "rotate-1", make this configurable
      // dragClass: "rotate-2", // doesn't seem to work
      draggable: "li",
      // handle: ".handle", // make configurable
      animation: 225,
      delay: 225,
      delayOnTouchOnly: true,
      touchStartThreshold: 5,
    });
  }

  disconnect() {
    this.sortable.destroy();
  }
}
