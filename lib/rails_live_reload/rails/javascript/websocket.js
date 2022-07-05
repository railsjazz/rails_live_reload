/*!
  Rails Live Reload 0.1.2
  Copyright © 2022 RailsJazz
  https://railsjazz.com
 */
var RailsLiveReload=function(){"use strict";const t="RELOAD";class e{static _instance;static get instance(){return e._instance||(e._instance=new this),e._instance}static start(){this.instance.start()}constructor(){this.initialize(),document.addEventListener("turbo:render",this.restart.bind(this))}initialize(){const{files:t,time:e,url:n,options:i}=JSON.parse(this.optionsNode.textContent);this.files=t,this.time=e,this.url=n,this.options=i}start(){throw"This should be implemented in subclass"}stop(){throw"This should be implemented in subclass"}restart(){this.stop(),this.initialize(),this.start()}fullReload(){window.location.reload()}get optionsNode(){const t=document.getElementById("rails-live-reload-options");if(!t)throw"Unable to find RailsLiveReload options";return t}}class n extends e{start(){this.connection||(this.connection=new WebSocket(function(t){if("function"==typeof t&&(t=t()),t&&!/^wss?:/i.test(t)){const e=document.createElement("a");return e.href=t,e.href=e.href,e.protocol=e.protocol.replace("http","ws"),e.href}return t}(this.url)),this.connection.onmessage=this.handleMessage.bind(this),this.connection.onopen=this.handleConnectionOpen.bind(this),this.connection.onclose=this.handleConnectionClosed.bind(this))}stop(){this.connection.close()}restart(){this.initialize(),this.setupConnection()}setupConnection(){this.connection.send(JSON.stringify({event:"setup",options:{files:this.files,dt:this.time}}))}handleConnectionOpen(t){this.retriesCount=0,this.setupConnection()}handleMessage(e){JSON.parse(e.data).command===t&&this.fullReload()}handleConnectionClosed(t){this.connection=void 0,!t.wasClean&&this.retriesCount<=10&&(this.retriesCount++,setTimeout((()=>{this.start()}),1e3*this.retriesCount))}}return n.start(),n}();