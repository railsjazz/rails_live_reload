module RailsLiveReload
  class Railtie < ::Rails::Engine

    if RailsLiveReload.enabled?
      initializer "rails_live_reload.middleware" do |app|
        if ::Rails::VERSION::MAJOR.to_i >= 5
          app.middleware.insert_after ActionDispatch::Executor, RailsLiveReload.middleware
        else
          begin
            app.middleware.insert_after ActionDispatch::Static, RailsLiveReload.middleware
          rescue
            app.middleware.insert_after Rack::SendFile, RailsLiveReload.middleware
          end
        end

        RailsLiveReload::Watcher.init
      end

      initializer :configure_metrics, after: :initialize_logger do
        ActiveSupport::Notifications.subscribe(
          /\.action_view/,
          RailsLiveReload::Instrument::MetricsCollector.new
        )
      end

      initializer :reset_current_request, after: :initialize_logger do |app|
        app.executor.to_run      { CurrentRequest.cleanup }
        app.executor.to_complete { CurrentRequest.cleanup }
      end
    end
  end
end
