import Base, { COMMANDS } from "./base";

export default class RailsLiveReload extends Base {
  start() {
    this.retriesCount = 0;
    this.timestamp = new Date();
    this.poll(this.timestamp);
  }

  stop() {
    this.timestamp = undefined;
  }

  async poll(timestamp) {
    if (this.timestamp !== timestamp) return;
    try {
      const formData = new FormData();
      formData.append("dt", this.time);
      formData.append("files", JSON.stringify(this.files));

      const response = await fetch(this.url, {
        method: "post",
        headers: { Accept: "application/json" },
        body: formData,
      });
      const data = await response.json();

      if (this.timestamp !== timestamp) return;
      this.retriesCount = 0;
      if (data.command === COMMANDS.RELOAD) {
        this.fullReload();
      } else {
        this.poll(timestamp);
      }
    } catch (error) {
      if (this.timestamp !== timestamp) return;
      this.retriesCount++;

      if (this.retriesCount < 10) {
        setTimeout(() => this.poll(timestamp), 5000);
      } else {
        this.stop();
      }
    }
  }
}

document.addEventListener("DOMContentLoaded", () => {
  RailsLiveReload.start();
});
