import Base, { COMMANDS } from "./base";

export default class RailsLiveReload extends Base {
  start() {
    if(this.interval) return;

    this.interval = setInterval(async () => {
      const formData = new FormData();
      formData.append("dt", this.time);
      formData.append("files", JSON.stringify(this.files));
      const response = await fetch(this.url, {
        method: "post",
        headers: { Accept: "application/json" },
        body: formData
      });

      const data = await response.json();

      if (data.command === COMMANDS.RELOAD) {
        this.stop();
        this.fullReload();
      }
    }, this.options.polling_interval);
  }

  restart() {
    this.initialize();
  }

  stop() {
    clearInterval(this.interval);
    this.interval = undefined;
  }
};

RailsLiveReload.start();
