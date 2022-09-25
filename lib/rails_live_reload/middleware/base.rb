module RailsLiveReload
  module Middleware
    class Base
      def initialize(app)
        @app = app
      end

      def call(env)
        dup.call!(env)
      end

      def call!(env)
        if env["REQUEST_PATH"].starts_with?(RailsLiveReload.config.url)
          ::Rails.logger.silence do
            @app.call(env)
          end
        else
          request = Rack::Request.new(env)
          status, headers, response = @app.call(env)

          if html?(headers) && response.respond_to?(:[]) && (status == 500 || (status.to_s =~ /20./ && request.get?))
            new_response = make_new_response(response[0])
            headers['Content-Length'] = new_response.bytesize.to_s
            response = [new_response]
          end

          [status, headers, response]
        end
      end

      private

      def make_new_response(body)
        index = body.rindex(/<\/body>/i) || body.rindex(/<\/html>/i)
        body.insert(index, <<~HTML.html_safe)
          <script defer type="text/javascript" src="#{RailsLiveReload.config.url}/script"></script>
          <script id="rails-live-reload-options" type="application/json">
            #{{
              files: CurrentRequest.current.data.to_a,
              time: Time.now.to_i,
              url: RailsLiveReload.config.url
            }.to_json}
          </script>
        HTML
      end

      def html?(headers)
        headers["Content-Type"].to_s.include?("text/html")
      end
    end
  end
end
