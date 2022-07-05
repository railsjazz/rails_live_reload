/*!
  Rails Live Reload 0.1.2
  Copyright © 2022 RailsJazz
  https://railsjazz.com
 */
var RailsLiveReload=function(){"use strict";const t="RELOAD";class s{static _instance;static get instance(){return s._instance||(s._instance=new this),s._instance}static start(){this.instance.start()}constructor(){this.initialize(),document.addEventListener("turbo:render",this.restart.bind(this))}initialize(){const{files:t,time:s,url:i,options:e}=JSON.parse(this.optionsNode.textContent);this.files=t,this.time=s,this.url=i,this.options=e}start(){throw"This should be implemented in subclass"}stop(){throw"This should be implemented in subclass"}restart(){this.stop(),this.initialize(),this.start()}fullReload(){window.location.reload()}get optionsNode(){const t=document.getElementById("rails-live-reload-options");if(!t)throw"Unable to find RailsLiveReload options";return t}}class i extends s{start(){this.retriesCount=0,this.timestamp=new Date,this.poll(this.timestamp)}stop(){this.timestamp=void 0}async poll(s){if(this.timestamp===s)try{const i=new FormData;i.append("dt",this.time),i.append("files",JSON.stringify(this.files));const e=await fetch(this.url,{method:"post",headers:{Accept:"application/json"},body:i}),n=await e.json();if(this.timestamp!==s)return;this.retriesCount=0,n.command===t?this.fullReload():this.poll(s)}catch(t){if(this.timestamp!==s)return;this.retriesCount++,this.retriesCount<10?setTimeout((()=>this.poll(s)),5e3):this.stop()}}}return i.start(),i}();