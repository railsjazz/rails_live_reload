module RailsLiveReload
  class << self
    def configure
      yield config
    end

    def config
      @_config ||= Config.new
    end

    def patterns
      config.patterns
    end

    def enabled?
      config.enabled
    end
  end

  class Config
    attr_reader :patterns
    attr_accessor :mode, :polling_interval, :timeout, :url, :watcher, :files, :enabled, :long_polling_sleep_duration

    def initialize
      @mode = :websocket
      @timeout = 30
      @long_polling_sleep_duration = 0.1
      @polling_interval = 100
      @url = "/rails/live/reload"
      @watcher = nil
      @files = {}
      @enabled = ::Rails.env.development?

      # These configs work for 95% apps, see README for more info
      @patterns = {
        %r{app/views/.+\.(erb|haml|slim)$} => :on_change,
        %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*} => :always
      }
      @default_patterns_changed = false
    end

    def watch(pattern, reload: :on_change)
      unless @default_patterns_changed
        @default_patterns_changed = true
        @patterns = {}
      end

      patterns[pattern] = reload
    end
  end
end
