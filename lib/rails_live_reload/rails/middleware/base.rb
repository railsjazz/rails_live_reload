module RailsLiveReload
  module Rails
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

          if env["REQUEST_PATH"] == RailsLiveReload.config.url
            rails_live_response(request)
          else
            @status, @headers, @response = @app.call(env)

            if html? && @response.respond_to?(:[]) && (@status == 500 || (@status.to_s =~ /20./ && request.get?))
              new_response = make_new_response(@response[0])
              @headers['Content-Length'] = new_response.bytesize.to_s
              @response = [new_response]
            end

            [@status, @headers, @response]
          end
        rescue Exception => ex
          puts ex.message
          puts ex.backtrace.take(10)
          raise ex
        end

        private

        def rails_live_response(request)
          raise NotImplementedError
        end

        def client_javascript(request)
          raise NotImplementedError
        end

        def make_new_response(body)
          body.sub("</head>", "</head>#{client_javascript}")
        end

        def html?
          @headers["Content-Type"].to_s.include?("text/html")
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
