module RailsLiveReload
  class Railtie < ::Rails::Engine
    def enabled?
      RailsLiveReload.enabled? && (defined?(::Rails::Server) || ENV['SERVER_PROCESS'])
    end

    initializer "rails_live_reload.middleware" do |app|
      if enabled?
        if ::Rails::VERSION::MAJOR.to_i >= 5
          app.middleware.insert_after ActionDispatch::Executor, RailsLiveReload::Middleware::Base
        else
          begin
            app.middleware.insert_after ActionDispatch::Static, RailsLiveReload::Middleware::Base
          rescue
            app.middleware.insert_after Rack::SendFile, RailsLiveReload::Middleware::Base
          end
        end
      end
    end

    initializer "rails_live_reload.watcher" do
      if enabled?
        RailsLiveReload::Watcher.init
      end
    end

    initializer "rails_live_reload.configure_metrics", after: :initialize_logger do
      if enabled?
        ActiveSupport::Notifications.subscribe(
          /\.action_view/,
          RailsLiveReload::Instrument::MetricsCollector.new
        )
      end
    end

    initializer "rails_live_reload.reset_current_request", after: :initialize_logger do |app|
      if enabled?
        app.executor.to_run      { CurrentRequest.cleanup }
        app.executor.to_complete { CurrentRequest.cleanup }
      end
    end

    initializer "rails_live_reload.routes" do
      config.after_initialize do |app|
        if enabled?
          app.routes.prepend do
            mount RailsLiveReload.server => RailsLiveReload.config.url, internal: true
          end
        end
      end
    end
  end
end