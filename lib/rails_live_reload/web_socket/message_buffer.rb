module RailsLiveReload
  module WebSocket
    # This class is basically copied from ActionCable
    # https://github.com/rails/rails/blob/v7.0.3/actioncable/lib/action_cable/connection/message_buffer.rb
    class MessageBuffer
      def initialize(connection)
        @connection = connection
        @buffered_messages = []
      end

      def append(message)
        if valid? message
          if processing?
            receive message
          else
            buffer message
          end
        else
          raise ArgumentError, "Couldn't handle non-string message: #{message.class}"
        end
      end

      def processing?
        @processing
      end

      def process!
        @processing = true
        receive_buffered_messages
      end

      private

      attr_reader :connection, :buffered_messages

      def valid?(message)
        message.is_a?(String)
      end

      def receive(message)
        connection.receive message
      end

      def buffer(message)
        buffered_messages << message
      end

      def receive_buffered_messages
        receive buffered_messages.shift until buffered_messages.empty?
      end
    end
  end
end
