module RailsLiveReload
  module Rails
    module Middleware
      class Polling < Base
        private

        def rails_live_response(request)
          [
            200,
            { 'Content-Type' => 'application/json' },
            [ RailsLiveReload::Command.new(request.params).payload.to_json ]
          ]
        end

        def client_javascript
          RailsLiveReload::Client.polling_js
        end
      end
    end
  end
end
