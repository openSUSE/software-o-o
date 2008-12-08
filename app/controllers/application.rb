# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'stringio'
require 'zlib'

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  # session :session_key => '_software_session_id'
  session :disabled => true
  layout "application_no_js"

  after_filter :set_vary_header
  after_filter :compress

  def set_vary_header
    self.response.headers['Vary'] = 'Accept-Encoding'
  end

  def compress
    enc = self.request.env['HTTP_ACCEPT_ENCODING']
    if enc and (md = enc.match(/gzip;?(q=([^,]*))?/))
      if md[1].nil? or md[2].to_f > 0.0
        if self.response.headers["Content-Transfer-Encoding"] != 'binary'
          logger.debug "compressing output"
          begin 
            ostream = StringIO.new
            gz = Zlib::GzipWriter.new(ostream)
            gz.write(self.response.body)
            self.response.body = ostream.string
            self.response.headers['Content-Encoding'] = 'gzip'
          ensure
            gz.close
          end
        end
      end
    end
  end

  def rescue_action_in_public(exception)
    @message = exception.message
    if request.xhr?
      render :template => "error", :layout => :false, :status => 404
    else
      render :template => 'error', :layout => "application", :status => 404
    end
  end
end
