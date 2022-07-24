module RailsLiveReload
  module WebSocket
    # This class is strongly based on ActionCable
    # https://github.com/rails/rails/blob/v7.0.3/actioncable/lib/action_cable/connection/base.rb
    class Base
      attr_reader :server, :env, :protocol, :request
      attr_reader :dt, :files

      delegate :event_loop, to: :server

      def initialize(server, request)
        @server, @request = server, request
        @env = request.env
        @websocket = RailsLiveReload::WebSocket::Wrapper.new(env, self, event_loop)
        @message_buffer = RailsLiveReload::WebSocket::MessageBuffer.new(self)
      end

      def process
        if websocket.possible?
          respond_to_successful_request
        else
          respond_to_invalid_request
        end
      end

      def receive(websocket_message)
        if websocket.alive?
          handle_channel_command decode(websocket_message)
        end
      end

      def handle_channel_command(payload)
        case payload['event']
        when 'setup'
          setup payload['options']
        else
          raise NotImplementedError
        end
      end

      def reload
        return if dt.nil? || files.nil? || RailsLiveReload::Checker.scan(dt, files).size.zero?

        transmit({command: "RELOAD"})
      end

      def transmit(cable_message)
        websocket.transmit encode(cable_message)
      end

      def close(reason: nil)
        transmit({
          type: RailsLiveReload::INTERNAL[:message_types][:disconnect],
          reason: reason
        })
        websocket.close
      end

      def beat
        transmit type: RailsLiveReload::INTERNAL[:message_types][:ping], message: Time.now.to_i
      end

      def on_open
        @protocol = websocket.protocol
        send_welcome_message

        message_buffer.process!
        server.add_connection(self)
      end

      def on_message(message)
        message_buffer.append message
      end

      def on_error(message)
        raise message
      end

      def on_close(reason, code)
        server.remove_connection(self)
      end

      private

      attr_reader :websocket
      attr_reader :message_buffer

      def setup(options)
        @dt = options['dt']
        @files = options['files']
      end

      def encode(message)
        message.to_json
      end

      def decode(message)
        JSON.parse message
      end

      def send_welcome_message
        transmit type: RailsLiveReload::INTERNAL[:message_types][:welcome]
      end

      def respond_to_successful_request
        websocket.rack_response
      end

      def respond_to_invalid_request
        close(reason: RailsLiveReload::INTERNAL[:disconnect_reasons][:invalid_request]) if websocket.alive?

        [ 404, { "Content-Type" => "text/plain" }, [ "Page not found" ] ]
      end
    end
  end
end
