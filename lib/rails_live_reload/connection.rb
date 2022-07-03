require 'faye/websocket'

module RailsLiveReload
  class Connection
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

    attr_reader :files, :dt

    def initialize(env)
      @ws = Faye::WebSocket.new(env)
      @ws.on :message, &method(:on_message)
      @ws.on :close do |event|
        @ws = nil
        self.class.remove_connection self
      end
    end

    def rack_response
      @ws.rack_response
    end

    def reload
      return if dt.nil? || files.nil? || RailsLiveReload::Checker.scan(dt, files).size.zero?

      @ws.send({command: "RELOAD"}.to_json)
    end

    private

    def on_message(event)
      data = JSON.parse event.data
      case data['event']
      when 'setup'
        setup data['options']
      else
        raise NotImplementedError
      end
    end

    def setup(options)
      @dt = options['dt']
      @files = options['files']
    end
  end
end
