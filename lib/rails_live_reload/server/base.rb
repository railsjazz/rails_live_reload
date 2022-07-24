module RailsLiveReload
  module Server
    class Base
      include RailsLiveReload::Server::Connections

      attr_reader :mutex

      def reload_all
        puts self.object_id
        puts mutex.object_id
        puts connections.object_id
        @mutex.synchronize do
          connections.each(&:reload)
        end
      end

      def initialize
        @mutex = Monitor.new
        @event_loop = nil
        @connections ||= []

        puts "+++++++++++++"
      end

      # Called by Rack to set up the server.
      def call(env)
        setup_heartbeat_timer
        request = Rack::Request.new(env)
        RailsLiveReload::WebSocket::Base.new(self, request).process.tap do
          puts self.object_id
          puts mutex.object_id
          puts connections.object_id
        end
      end

      def restart
        # connections.each do |connection|
          # connection.close(reason: ActionCable::INTERNAL[:disconnect_reasons][:server_restart])
        # end

        # @mutex.synchronize do
        #   # Shutdown the worker pool
        #   @worker_pool.halt if @worker_pool
        #   @worker_pool = nil

        #   # Shutdown the pub/sub adapter
        #   # @pubsub.shutdown if @pubsub
        #   # @pubsub = nil
        # end
      end

      def event_loop
        @event_loop || @mutex.synchronize { @event_loop ||= RailsLiveReload::WebSocket::EventLoop.new }
      end

      # The worker pool is where we run connection callbacks and channel actions. We do as little as possible on the server's main thread.
      # The worker pool is an executor service that's backed by a pool of threads working from a task queue. The thread pool size maxes out
      # at 4 worker threads by default. Tune the size yourself with <tt>config.action_cable.worker_pool_size</tt>.
      #
      # Using Active Record, Redis, etc within your channel actions means you'll get a separate connection from each thread in the worker pool.
      # Plan your deployment accordingly: 5 servers each running 5 Puma workers each running an 8-thread worker pool means at least 200 database
      # connections.
      #
      # Also, ensure that your database connection pool size is as least as large as your worker pool size. Otherwise, workers may oversubscribe
      # the database connection pool and block while they wait for other workers to release their connections. Use a smaller worker pool or a larger
      # database connection pool instead.
      # def worker_pool
      #   @worker_pool || @mutex.synchronize { @worker_pool ||= ActionCable::Server::Worker.new(max_size: config.worker_pool_size) }
      # end



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

      def open_connections_statistics
        connections.map(&:statistics)
      end
    end
  end
end
