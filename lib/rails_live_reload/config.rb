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
    attr_accessor :mode, :polling_interval, :timeout, :url, :watcher, :files, :enabled

    def initialize
      @mode = :long_polling
      @timeout = 30
      @patterns = {}
      @polling_interval = 100
      @url = "/rails/live/reload"
      @watcher = nil
      @files = {}
      @enabled = ::Rails.env.development? && !defined?(Rails::Console)
    end

    def watch(pattern, reload: :on_change)
      patterns[pattern] = reload
    end
  end
end
