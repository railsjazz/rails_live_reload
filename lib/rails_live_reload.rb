require "listen"
require "rails_live_reload/version"
require "rails_live_reload/config"
require "rails_live_reload/client"
require "rails_live_reload/watcher"
require "rails_live_reload/rails/middleware/long_poling"
require "rails_live_reload/rails/middleware/poling"
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
    when :poling then RailsLiveReload::Rails::Middleware::Poling
    when :long_poling then RailsLiveReload::Rails::Middleware::LongPoling
    end
  end
end

RailsLiveReload.configure do |config|
  config.watch %r{app/views/.+\.(erb|haml|slim)$}
  config.watch %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always
end
