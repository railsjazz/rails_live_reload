module RailsLiveReload
  module Instrument
    class MetricsCollector
      def call(event_name, started, finished, event_id, payload)
        CurrentRequest.current.data.add(payload[:identifier])
      end
    end
  end
end
