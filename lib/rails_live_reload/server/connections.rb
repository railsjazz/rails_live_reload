module RailsLiveReload
  module Server
    # This class is strongly based on ActionCable
    # https://github.com/rails/rails/blob/v7.0.3/actioncable/lib/action_cable/server/connections.rb
    module Connections
      BEAT_INTERVAL = 3

      def connections
        @connections || @mutex.synchronize { @connections ||= Concurrent::Array.new }
      end

      def add_connection(connection)
        connections << connection
      end

      def remove_connection(connection)
        connections.delete connection
      end

      def setup_heartbeat_timer
        @heartbeat_timer ||= event_loop.timer(BEAT_INTERVAL) do
          event_loop.post { connections.each(&:beat) }
        end
      end
    end
  end
end
