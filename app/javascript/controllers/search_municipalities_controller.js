import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-municipalities"
export default class extends Controller {
  static targets = ["form", "input"]
  connect() {
  }
}
