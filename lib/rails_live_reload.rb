require "listen"
require "rails_live_reload/version"
require "rails_live_reload/client"
require "rails_live_reload/watcher"
require "rails_live_reload/rails/middleware"
require "rails_live_reload/instrument/metrics_collector"
require "rails_live_reload/thread/current_request"
require "rails_live_reload/checker"
require "rails_live_reload/command"
require "rails_live_reload/engine"

module RailsLiveReload
  mattr_accessor :files
  @@files = {}

  mattr_accessor :watcher
  @@watcher = nil

  mattr_accessor :url
  @@url = "/rails/live/reload"

  mattr_accessor :patterns
  @@patterns = {}

  def self.setup
    yield(self)
  end

  def self.watch(pattern, reload: :on_change)
    RailsLiveReload.patterns[pattern] = reload
  end
end

# default watch settings
RailsLiveReload.setup do |config|
  # app
  config.watch %r{app/views/.+\.(erb|haml|slim)$}
  config.watch %r{(app|vendor)/(assets|javascripts)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always
  # config.watch %r{app/helpers/.+\.rb}, reload: :always
  # config.watch %r{config/locales/.+\.yml}, reload: :always

  # # Rails Assets Pipeline
end