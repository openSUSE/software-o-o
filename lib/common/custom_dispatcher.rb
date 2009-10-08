#
# taken from http://wiki.rubyonrails.org/rails/pages/HowtoConfigureTheErrorPageForYourRailsApp
#

class << Dispatcher
  def dispatch(cgi = CGI.new, session_options = ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS)
    begin
      request = ActionController::CgiRequest.new(cgi, session_options),
      response = ActionController::CgiResponse.new(cgi)
      prepare_application
      ActionController::Routing::Routes.recognize!(request).process(request, response).out
    rescue Object => exception
      begin
        ActionController::Base.process_with_exception(request, response, exception).out
      rescue
        # The rescue action above failed also, probably for the same reason
        # the original action failed.  Do something simple which is unlikely
        # to fail.  You might want to redirect to a static page instead of this.
        e = exception
        cgi.header("type" => "text/html")
        cgi.out('cookie' => '') do
          <<-RESPONSE
          <html>
          <head><title>Application Error</title></head>
          <body>
          <h1>Application Error</h1>
          <b><pre>#{e.class}: #{e.message}</pre></b>

          <pre>#{e.backtrace.join("\n")}</pre>
          </body>
          </html>
          RESPONSE
        end
      end
    ensure
      reset_application
    end
  end
end
