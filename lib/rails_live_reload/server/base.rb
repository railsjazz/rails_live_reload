require 'rails_live_reload/web_socket/event_loop'
require 'rails_live_reload/web_socket/message_buffer'
require 'rails_live_reload/web_socket/wrapper'
require 'rails_live_reload/web_socket/client_socket'
require 'rails_live_reload/web_socket/stream'
require 'rails_live_reload/web_socket/base'

module RailsLiveReload
  module Server
    # This class is based on ActionCable
    # https://github.com/rails/rails/blob/v7.0.3/actioncable/lib/action_cable/server/base.rb
    class Base
      include RailsLiveReload::Server::Connections

      attr_reader :mutex

      def reload_all
        @mutex.synchronize do
          connections.each(&:reload)
        end
      end

      def initialize
        @mutex = Monitor.new
        @event_loop = nil
      end

      # Called by Rack to set up the server.
      def call(env)
        case env["REQUEST_PATH"]
        when RailsLiveReload.config.url
          setup_socket
          setup_heartbeat_timer
          request = Rack::Request.new(env)
          RailsLiveReload::WebSocket::Base.new(self, request).process
        when "#{RailsLiveReload.config.url}/script"
          content = client_javascript
          [200, {'Content-Type' => 'application/javascript', 'Content-Length' => content.size.to_s, 'Cache-Control' => 'no-store'}, [content]]
        else
          raise ActionController::RoutingError, 'Not found'
        end
      end

      def client_javascript
        @client_javascript || @mutex.synchronize { @client_javascript ||= File.open(File.join(File.dirname(__FILE__), "../javascript/websocket.js")).read }
      end

      def event_loop
        @event_loop || @mutex.synchronize { @event_loop ||= RailsLiveReload::WebSocket::EventLoop.new }
      end

      def setup_socket
        @socket ||= UNIXSocket.open(RailsLiveReload.config.socket_path).tap do |socket|
          Thread.new do
            loop do
              data = JSON.parse socket.readline

              case data["event"]
              when RailsLiveReload::INTERNAL[:socket_events][:reload]
                RailsLiveReload::Checker.files = data['files']

                reload_all
              else
                raise NotImplementedError
              end
            end
          end
        end
      end
    end
  end
end
