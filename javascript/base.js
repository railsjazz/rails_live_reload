export const COMMANDS = {
  RELOAD: 'RELOAD'
};

export default class Base {
  static _instance;

  static get instance() {
    if(Base._instance) return Base._instance;

    Base._instance = new this();
    return Base._instance;
  }

  static start() {
    this.instance.start();
  }

  constructor() {
    this.initialize();

    document.addEventListener('turbo:render', this.restart.bind(this));
  }

  initialize() {
    const { files, time, url, options } = JSON.parse(this.optionsNode.textContent);

    this.files = files;
    this.time = time;
    this.url = url;
    this.options = options;
  }

  start() {
    throw 'This should be implemented in subclass';
  }

  stop() {
    throw 'This should be implemented in subclass';
  }

  restart() {
    this.stop();
    this.initialize();
    this.start();
  }

  fullReload() {
    window.location.reload();
  }

  get optionsNode() {
    const node = document.getElementById('rails-live-reload-options');
    if(!node) throw 'Unable to find RailsLiveReload options';

    return node;
  }
}
