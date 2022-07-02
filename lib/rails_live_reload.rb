require "listen"
require "rails_live_reload/version"
require "rails_live_reload/config"
require "rails_live_reload/client"
require "rails_live_reload/watcher"
require "rails_live_reload/rails/middleware/base"
require "rails_live_reload/rails/middleware/long_polling"
require "rails_live_reload/rails/middleware/event_source"
require "rails_live_reload/rails/middleware/polling"
require "rails_live_reload/instrument/metrics_collector"
require "rails_live_reload/thread/current_request"
require "rails_live_reload/checker"
require "rails_live_reload/command"
require "rails_live_reload/engine"

module RailsLiveReload
  mattr_accessor :watcher
  @@watcher = {}

  def self.middleware
    case config.mode
    when :polling then RailsLiveReload::Rails::Middleware::Polling
    when :long_polling then RailsLiveReload::Rails::Middleware::LongPolling
    when :sse then RailsLiveReload::Rails::Middleware::EventSource
    end
  end
end
