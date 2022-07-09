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
        request = Rack::Request.new(env)

        case env["REQUEST_PATH"]
        when RailsLiveReload.config.url
          main_rails_live_response(request)
        when "#{RailsLiveReload.config.url}/script"
          content = client_javascript
          [200, {'Content-Type' => 'application/javascript', 'Content-Length' => content.size.to_s, 'Cache-Control' => 'no-store'}, [content]]
        else
          status, headers, response = @app.call(env)

          if html?(headers) && response.respond_to?(:[]) && (status == 500 || (status.to_s =~ /20./ && request.get?))
            new_response = make_new_response(response[0])
            headers['Content-Length'] = new_response.bytesize.to_s
            response = [new_response]
          end

          [status, headers, response]
        end
      rescue Exception => ex
        puts ex.message
        puts ex.backtrace.take(10)
        raise ex
      end

      private

      def main_rails_live_response(request)
        raise NotImplementedError
      end

      def client_javascript
        @client_javascript ||= File.open(File.join(File.dirname(__FILE__), "../javascript/#{RailsLiveReload.config.mode}.js")).read
      end

      def make_new_response(body)
        body = body.sub("</head>", <<~HTML.html_safe)
          <script defer type="text/javascript" src="#{RailsLiveReload.config.url}/script"></script>
          </head>
        HTML
        body.sub("</body>", <<~HTML.html_safe)
          <script id="rails-live-reload-options" type="application/json">
            #{{
              files: CurrentRequest.current.data.to_a,
              time: Time.now.to_i,
              url: RailsLiveReload.config.url,
              options: javascript_options
            }.to_json}
          </script>
          </body>
        HTML
      end

      def javascript_options
        {}
      end

      def html?(headers)
        headers["Content-Type"].to_s.include?("text/html")
      end
    end
  end
end
