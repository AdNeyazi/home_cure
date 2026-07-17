import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "password"]

  fill(event) {
    const { email, password } = event.currentTarget.dataset

    if (email && this.hasEmailTarget) {
      this.emailTarget.value = email
      this.emailTarget.dispatchEvent(new Event("input", { bubbles: true }))
    }

    if (password && this.hasPasswordTarget) {
      this.passwordTarget.value = password
      this.passwordTarget.dispatchEvent(new Event("input", { bubbles: true }))
    }
  }
}
