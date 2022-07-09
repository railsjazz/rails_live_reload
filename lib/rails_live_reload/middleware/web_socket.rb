require 'rails_live_reload/web_socket/event_loop'
require 'rails_live_reload/web_socket/message_buffer'
require 'rails_live_reload/web_socket/wrapper'
require 'rails_live_reload/web_socket/client_socket'
require 'rails_live_reload/web_socket/stream'
require 'rails_live_reload/web_socket/base'

module RailsLiveReload
  module Middleware
    class WebSocket < Base
      attr_reader :mutex, :event_loop

      delegate :connections, :add_connection, :remove_connection, to: :class

      class << self
        def connections
          @connections ||= []
        end

        def add_connection(connection)
          connections << connection
        end
  
        def remove_connection(connection)
          connections.delete connection
        end  
      end

      def initialize(env)
        @mutex = Monitor.new
        @event_loop = nil
        super
      end

      def main_rails_live_response(request)
        setup_heartbeat_timer
        RailsLiveReload::WebSocket::Base.new(self, request).process
      end

      def setup_heartbeat_timer
        @heartbeat_timer ||= event_loop.timer(3) do
          event_loop.post { connections.each(&:beat) }
        end
      end

      def event_loop
        @event_loop || @mutex.synchronize { @event_loop ||= RailsLiveReload::WebSocket::EventLoop.new }
      end
    end
  end
end
