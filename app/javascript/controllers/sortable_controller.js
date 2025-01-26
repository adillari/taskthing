import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  static values = {
    onEnd: { type: String, default: null },
    draggable: { type: String, default: "li" },
    delayOnMobile: { type: Boolean, default: true },
    handle: { type: String, default: null },
  };

  connect() {
    let config = {
      ghostClass: "!opacity-0",
      draggable: this.draggableValue,
      animation: 225,
      touchStartThreshold: 5,
    };
    if (this.handleValue) config.handle = this.handleValue;
    if (this.onEndValue) config.onEnd = this.onEndValue;
    if (this.delayOnMobileValue) {
      config.delay = 225;
      config.delayOnTouchOnly = true;
    }
    this.sortable = Sortable.create(this.element, config);
  }

  disconnect() {
    this.sortable.destroy();
  }
}
