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
    attr_reader :patterns, :polling_interval, :timeout, :mode, :long_polling_sleep_duration
    attr_accessor :url, :watcher, :files, :enabled

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

    def mode=(mode)
      warn "[DEPRECATION] RailsLiveReload 'mode' configuration is deprecated and will be removed in future versions #{caller.first}"
      @mode = mode
    end

    def polling_interval=(polling_interval)
      warn "[DEPRECATION] RailsLiveReload 'polling_interval' configuration is deprecated and will be removed in future versions #{caller.first}"
      @polling_interval = polling_interval
    end

    def timeout=(timeout)
      warn "[DEPRECATION] RailsLiveReload 'timeout' configuration is deprecated and will be removed in future versions #{caller.first}"
      @timeout = timeout
    end

    def long_polling_sleep_duration=(long_polling_sleep_duration)
      warn "[DEPRECATION] RailsLiveReload 'long_polling_sleep_duration' configuration is deprecated and will be removed in future versions #{caller.first}"
      @long_polling_sleep_duration = long_polling_sleep_duration
    end
  end
end
