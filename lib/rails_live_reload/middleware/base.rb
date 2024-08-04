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
          request = ActionDispatch::Request.new(env)
          status, headers, body = @app.call(env)

          if html?(headers) && (status == 500 || (status.to_s =~ /20./ && request.get?))
            return inject_rails_live_reload(request, status, headers, body)
          end

          [status, headers, body]
        end
      end

      private

      def inject_rails_live_reload(request, status, headers, body)
        response = Rack::Response.new([], status, headers)
        
        nonce = request&.content_security_policy_nonce
        if String === body
          response.write make_new_response(body, nonce)
        else
          body.each { |fragment| response.write make_new_response(fragment, nonce) }
        end
        body.close if body.respond_to?(:close)
        response.finish
      end

      def make_new_response(body, nonce)
        index = body.rindex(/<\/body>/i) || body.rindex(/<\/html>/i)
        return body if index.nil?

        body.insert(index, <<~HTML.html_safe)
          <script defer type="text/javascript" src="#{RailsLiveReload.config.url}/script"></script>
          <script id="rails-live-reload-options" type="application/json" nonce="#{nonce}">
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
