class ApiConnect

  class Error < Exception; end

  def self.get(path, limit = 10)
    uri_str = "#{CONFIG['api_host']}/#{path}".gsub(' ', '%20')
    uri_str = path if path.match( /^http/ )
    uri = URI.parse(uri_str)
    logger.debug "Loading from api: #{uri_str}"
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      if  uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      api_user = CONFIG['api_username']
      api_pass = CONFIG['api_password']
      request['x-username'] = api_user
      # if you know the cookie, you can bypass login - useful in production ;)
      request['X-opensuse_data'] = CONFIG['opensuse_cookie'] if CONFIG['opensuse_cookie']
      request.basic_auth  api_user, api_pass unless (api_user.blank? || api_pass.blank?)
      http.read_timeout = 15
      response = http.request(request)
      case response
      when Net::HTTPSuccess then response;
      when Net::HTTPRedirection then
        if limit
          get(response['location'], limit - 1)
        else
          raise Error.new "Recursive redirect"
        end
      else
        raise Error.new "Response was: #{response} #{response.body}"
      end
    rescue Exception => e
      raise Error.new "Error connecting to #{uri_str}: #{e.to_s}"
    end
  end


  def self.logger
    Rails.logger
  end

end
