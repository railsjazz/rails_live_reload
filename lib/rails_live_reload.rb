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

  mattr_accessor :timeout
  @@timeout = 100

  mattr_accessor :enabled
  @@enabled = true

  def self.setup
    yield(self)
  end

  def self.watch(pattern, reload: :on_change)
    RailsLiveReload.patterns[pattern] = reload
  end
end

if defined?(IRB)
  RailsLiveReload.enabled = false
end

# default watch settings
RailsLiveReload.setup do |config|
  config.watch %r{app/views/.+\.(erb|haml|slim)$}
  config.watch %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always
end