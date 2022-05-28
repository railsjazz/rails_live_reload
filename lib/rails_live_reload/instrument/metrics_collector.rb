module RailsLiveReload
  module Instrument
    class MetricsCollector
      # render_template.action_view
      # {
      #   identifier: "/Users/adam/projects/notifications/app/views/posts/index.html.erb",
      #   layout: "layouts/application"
      # }
      # render_partial.action_view
      # {
      #   identifier: "/Users/adam/projects/notifications/app/views/posts/_form.html.erb"
      # }
      # render_collection.action_view
      # {
      #   identifier: "/Users/adam/projects/notifications/app/views/posts/_post.html.erb",
      #   count: 3,
      #   cache_hits: 0
      # }
      # render_layout.action_view
      # {
      #   identifier: "/Users/adam/projects/notifications/app/views/layouts/application.html.erb"
      # }
      def call(event_name, started, finished, event_id, payload)
        CurrentRequest.current.data.add payload[:identifier]
      end
    end
  end
end