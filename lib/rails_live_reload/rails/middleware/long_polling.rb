module RailsLiveReload
  module Rails
    module Middleware
      class LongPolling < Base
        private

        def rails_live_response(request)
          params = request.params
          body = lambda do |stream|
            new_thread do
              counter = 0

              loop do
                command = RailsLiveReload::Command.new(params)

                if command.reload?
                  stream.write(command.payload.to_json) and break
                end

                sleep 0.2
                counter += 1

                stream.write(command.payload.to_json) and break if counter >= 140
              end
            ensure
              stream.close
            end
          end

          [ 200, { 'Content-Type' => 'application/json', 'rack.hijack' => body }, nil ]
        end

        def client_javascript
          RailsLiveReload::Client.long_polling_js
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
end
