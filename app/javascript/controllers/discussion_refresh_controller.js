import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Discussion refresh connected");

    this.refreshInterval = setInterval(() => {
      this.element.reload();
    }, 3000);
  }

  disconnect() {
    clearInterval(this.refreshInterval);
  }
}
