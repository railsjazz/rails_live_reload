module RailsLiveReload
  class Railtie < ::Rails::Engine
    if RailsLiveReload.enabled? && defined?(::Rails::Server)
      initializer "rails_live_reload.middleware" do |app|
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

      initializer "rails_live_reload.watcher" do
        RailsLiveReload::Watcher.init
      end

      initializer "rails_live_reload.configure_metrics", after: :initialize_logger do
        ActiveSupport::Notifications.subscribe(
          /\.action_view/,
          RailsLiveReload::Instrument::MetricsCollector.new
        )
      end

      initializer "rails_live_reload.reset_current_request", after: :initialize_logger do |app|
        app.executor.to_run      { CurrentRequest.cleanup }
        app.executor.to_complete { CurrentRequest.cleanup }
      end

      initializer "rails_live_reload.routes" do
        config.after_initialize do |app|
          app.routes.prepend do
            mount RailsLiveReload.server => RailsLiveReload.config.url, internal: true
          end
        end
      end
    end
  end
end
