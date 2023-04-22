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
    attr_accessor :url, :watcher, :files, :enabled

    def initialize
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

    def root_path
      @root_path ||= ::Rails.application.root
    end

    def watch(pattern, reload: :on_change)
      unless @default_patterns_changed
        @default_patterns_changed = true
        @patterns = {}
      end

      patterns[pattern] = reload
    end

    def socket_path
      root_path.join('tmp/sockets/rails_live_reload.sock').then do |path|
        break path if path.to_s.size <= 104 # 104 is the max length of a socket path

        puts "Unable to create socket path inside the project, using /tmp instead"
        app_name = ::Rails.application.class.name.split('::').first.underscore
        Pathname.new("/tmp/rails_live_reload_#{app_name}.sock")
      end
    end
  end
end
