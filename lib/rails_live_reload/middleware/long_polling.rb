module RailsLiveReload
  module Middleware
    class LongPolling < Base
      private

      def main_rails_live_response(request)
        params = request.params
        body = lambda do |stream|
          new_thread do
            counter = 0

            loop do
              command = RailsLiveReload::Command.new(params)

              if command.reload?
                stream.write(command.payload.to_json) and break
              end

              sleep(RailsLiveReload.config.long_polling_sleep_duration)
              counter += 1

              stream.write(command.payload.to_json) and break if counter >= max_sleeps_count
            end
          ensure
            stream.close
          end
        end

        [ 200, { 'Content-Type' => 'application/json', 'rack.hijack' => body }, nil ]
      end

      def max_sleeps_count
        RailsLiveReload.config.timeout * (1 / RailsLiveReload.config.long_polling_sleep_duration)
      end

      def new_thread
        Thread.new {
          t2 = Thread.current
          t2.abort_on_exception = true
          yield
        }
      end
    end
  end
end
