class ApiConnect

  def self.get(path)
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
      request.basic_auth  api_user, api_pass unless (api_user.blank? || api_pass.blank?)
      http.read_timeout = 15
      response = http.request(request)
      case response
      when Net::HTTPSuccess then response;
      else
        raise "Response was: #{response} #{response.body}"
      end
    rescue Exception => e
      logger.error "Error connecting to #{uri_str}: #{e.to_s}"
      raise "Error connecting to OBS API: #{e.to_s}"
      return nil
    end
  end


  def self.logger
    Rails.logger
  end

end
