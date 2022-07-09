require "listen"
require "rails_live_reload/version"
require "rails_live_reload/config"
require "rails_live_reload/watcher"
require "rails_live_reload/middleware/base"
require "rails_live_reload/middleware/long_polling"
require "rails_live_reload/middleware/web_socket"
require "rails_live_reload/middleware/polling"
require "rails_live_reload/instrument/metrics_collector"
require "rails_live_reload/thread/current_request"
require "rails_live_reload/checker"
require "rails_live_reload/command"
require "rails_live_reload/engine"

module RailsLiveReload
  mattr_accessor :watcher
  @@watcher = {}

  INTERNAL = {
    message_types: {
      welcome: "welcome",
      disconnect: "disconnect",
      ping: "ping",
    },
    disconnect_reasons: {
      invalid_request: "invalid_request",
      remote: "remote"
    },
    protocols: ["rails-live-reload-v1-json"].freeze
  }

  def self.middleware
    case config.mode
    when :polling then RailsLiveReload::Middleware::Polling
    when :long_polling then RailsLiveReload::Middleware::LongPolling
    when :websocket then RailsLiveReload::Middleware::WebSocket
    end
  end
end
