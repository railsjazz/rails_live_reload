import Base, { COMMANDS } from "./base";

// This was copied from actioncable
// https://github.com/rails/rails/blob/31b1403919eec0973921ab42251bfbbf3d4422b6/actioncable/app/javascript/action_cable/consumer.js#L60
function createWebSocketURL(url) {
  if (typeof url === "function") {
    url = url();
  }

  if (url && !/^wss?:/i.test(url)) {
    const a = document.createElement("a");
    a.href = url;
    // Fix populating Location properties in IE. Otherwise, protocol will be blank.
    a.href = a.href;
    a.protocol = a.protocol.replace("http", "ws");
    return a.href;
  } else {
    return url;
  }
}

export default class RailsLiveReload extends Base {
  start() {
    if (this.connection) return;

    this.connection = new WebSocket(createWebSocketURL(this.url));
    this.connection.onmessage = this.handleMessage.bind(this);
    this.connection.onopen = this.handleConnectionOpen.bind(this);
    this.connection.onclose = this.handleConnectionClosed.bind(this);
  }

  stop() {
    this.connection.close();
  }

  restart() {
    this.initialize();
    this.setupConnection();
  }

  setupConnection() {
    this.connection.send(
      JSON.stringify({
        event: "setup",
        options: {
          files: this.files,
          dt: this.time,
        },
      })
    );
  }

  handleConnectionOpen(e) {
    this.retriesCount = 0;
    this.setupConnection();
  }

  handleMessage(e) {
    const data = JSON.parse(e.data);

    if (data.command === COMMANDS.RELOAD) {
      this.fullReload();
    }
  }

  handleConnectionClosed(e) {
    this.connection = undefined;
    if (!e.wasClean && this.retriesCount <= 10) {
      this.retriesCount++;
      setTimeout(() => {
        this.start();
      }, 1000 * this.retriesCount);
    }
  }
}

RailsLiveReload.start();
