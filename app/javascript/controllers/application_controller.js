import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "indicator"]

  connect() {
    document.addEventListener('turbo:submit-start', this.removeModal.bind(this))
    document.addEventListener('turbo:before-fetch-request', this.#showSpinner.bind(this))
    document.addEventListener('turbo:before-fetch-response', this.#hideSpinner.bind(this))
    window.addEventListener('focus', () => {
      console.log('Window is focused');
    })
    window.addEventListener('blur', () => {
      console.log('Window is blurred');
    })
    document.addEventListener('visibilitychange', () => {
      if (document.visibilityState === 'visible') {
        console.log('Page is visible');
      } else {
        console.log('Page is hidden');
      }
    })
  }

  disconnect() {
    document.removeEventListener('turbo:submit-start', this.removeModal.bind(this))
    document.removeEventListener('turbo:before-fetch-request', this.#showSpinner.bind(this))
    document.removeEventListener('turbo:before-fetch-response', this.#hideSpinner.bind(this))
  }

  removeModal() {
    this.hasModalTarget && this.modalTarget.remove()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  // private

  #showSpinner(event) {
    if (this.#isPrefetchRequest(event)) return
    this.hasIndicatorTarget && (this.indicatorTarget.hidden = false)
  }

  #hideSpinner() {
    this.hasIndicatorTarget && (this.indicatorTarget.hidden = true)
  }

  #isPrefetchRequest(event) {
    return (event.detail.fetchOptions.headers["X-Sec-Purpose"] === "prefetch")
  }
}
