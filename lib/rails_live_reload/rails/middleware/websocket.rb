module RailsLiveReload
  module Rails
    module Middleware
      class Websocket < Base
        private

        def main_rails_live_response(request)
          params = request.params

          connection = Connection.new(request.env)

          Connection.add_connection(connection)

          connection.rack_response
        end
      end
    end
  end
end
