module RailsLiveReload
  class Railtie < ::Rails::Engine

    initializer 'rails_live_reload.helpers' do
      ActiveSupport.on_load :action_view do
        #include RailsLiveReload::Helper
      end
    end

    initializer "rails_live_reload.middleware" do |app|
      if ::Rails::VERSION::MAJOR.to_i >= 5
        app.middleware.insert_after ActionDispatch::Executor, RailsLiveReload::Rails::Middleware
      else
        begin
          app.middleware.insert_after ActionDispatch::Static, RailsLiveReload::Rails::Middleware
        rescue
          app.middleware.insert_after Rack::SendFile, RailsLiveReload::Rails::Middleware
        end
      end

      RailsLiveReload::Watcher.new(
        folder: (app.root.to_s + "/app")
      )
    end

    initializer :configure_metrics, after: :initialize_logger do
      ActiveSupport::Notifications.subscribe(
        /\.action_view/,
        RailsLiveReload::Instrument::MetricsCollector.new
      )
    end

  end
end
