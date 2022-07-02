require 'faye/websocket'

module RailsLiveReload
  module Rails
    module Middleware
      class EventSource < Base
        private

        def main_rails_live_response(request)
          params = request.params

          es = Faye::EventSource.new(request.env)

          new_thread do
            loop do
              command = RailsLiveReload::Command.new(params)

              if command.reload?
                es.send(command.payload.to_json) and break
              end

              sleep(RailsLiveReload.config.long_polling_sleep_duration)
            end
          end

          es.rack_response
        end

        def javascript_configs
          { files_param: CurrentRequest.current.data.to_a.map { |file| "files[]=#{file}" }.join('&') }
        end
      end
    end
  end
end
