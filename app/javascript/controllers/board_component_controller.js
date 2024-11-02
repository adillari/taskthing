import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["lane"]

  toggleLane({ target }) {
    const lane = target.closest("turbo-frame")
    const laneExpanded = target.innerText === "unfold_less"

    if (laneExpanded) {
      this.laneTargets.forEach((lane) => {
        lane.hidden = false
        target.innerText = "unfold_more"
      })
    } else {
      this.laneTargets.forEach((lane) => { lane.hidden = true })
      lane.hidden = false
      target.innerText = "unfold_less"
    }
  }
}
