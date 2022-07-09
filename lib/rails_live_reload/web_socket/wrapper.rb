require "websocket/driver"

module RailsLiveReload
  module WebSocket
    # This class is basically copied from ActionCable
    # https://github.com/rails/rails/blob/v7.0.3/actioncable/lib/action_cable/connection/web_socket.rb
    class Wrapper
      delegate :transmit, :close, :protocol, :rack_response, to: :websocket

      def initialize(env, event_target, event_loop, protocols: RailsLiveReload::INTERNAL[:protocols])
        @websocket = ::WebSocket::Driver.websocket?(env) ? ClientSocket.new(env, event_target, event_loop, protocols) : nil
      end

      def possible?
        websocket
      end

      def alive?
        websocket && websocket.alive?
      end

      private

      attr_reader :websocket
    end
  end
end
