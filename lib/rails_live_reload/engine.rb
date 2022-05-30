module RailsLiveReload
  class Railtie < ::Rails::Engine

    initializer "rails_live_reload.middleware" do |app|
      next unless RailsLiveReload.enabled

      if ::Rails::VERSION::MAJOR.to_i >= 5
        app.middleware.insert_after ActionDispatch::Executor, RailsLiveReload::Rails::Middleware
      else
        begin
          app.middleware.insert_after ActionDispatch::Static, RailsLiveReload::Rails::Middleware
        rescue
          app.middleware.insert_after Rack::SendFile, RailsLiveReload::Rails::Middleware
        end
      end

      RailsLiveReload::Watcher.init
    end

    initializer :configure_metrics, after: :initialize_logger do
      next unless RailsLiveReload.enabled

      ActiveSupport::Notifications.subscribe(
        /\.action_view/,
        RailsLiveReload::Instrument::MetricsCollector.new
      )
    end

  end
end
