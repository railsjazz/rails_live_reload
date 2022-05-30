require "listen"
require "rails_live_reload/version"
require "rails_live_reload/config"
require "rails_live_reload/client"
require "rails_live_reload/watcher"
require "rails_live_reload/rails/middleware/base"
require "rails_live_reload/rails/middleware/long_polling"
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
    end
  end
end

# These configs work for 95% apps, see README for more info
RailsLiveReload.configure do |config|
  config.watch %r{app/views/.+\.(erb|haml|slim)$}
  config.watch %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always
end
