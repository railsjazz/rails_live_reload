module RailsLiveReload
  module Rails
    module Middleware
      class Polling < Base
        private

        def main_rails_live_response(request)
          [
            200,
            { 'Content-Type' => 'application/json' },
            [ RailsLiveReload::Command.new(request.params).payload.to_json ]
          ]
        end

        def javascript_options
          { polling_interval: RailsLiveReload.config.polling_interval }
        end
      end
    end
  end
end
