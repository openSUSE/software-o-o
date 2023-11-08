# frozen_string_literal: true

class ApiConnect
  class Error < RuntimeError; end

  def self.get(path, limit = 10)
    config = Rails.configuration.x
    uri_str = "#{config.api_host}/#{path}".gsub(' ', '%20')
    uri_str = path if /^http/.match?(path)
    uri = URI.parse(uri_str)
    logger.debug "Loading from api: #{uri_str}"
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      request['x-username'] = config.api_username
      # if you know the cookie, you can bypass login - useful in production ;)
      request['X-opensuse_data'] = config.opensuse_cookie if config.opensuse_cookie
      request.basic_auth config.api_username, config.api_password unless config.api_username.blank? || config.api_password.blank?
      http.read_timeout = 15
      response = http.request(request)
      case response
      when Net::HTTPSuccess then response
      when Net::HTTPRedirection
        raise Error, 'Recursive redirect' unless limit

        get(response['location'], limit - 1)
      else
        raise Error, "Response was: #{response} #{response.body}"
      end
    rescue StandardError => e
      raise Error, "Error connecting to #{uri_str}: #{e}"
    end
  end

  def self.logger
    Rails.logger
  end
end
