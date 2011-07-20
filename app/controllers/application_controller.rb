# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'net/https'

class ApplicationController < ActionController::Base

  before_filter :set_language
  before_filter :set_distributions
  
  helper :all # include all helpers, all the time
  require "rexml/document"

  init_gettext('software')

  class MissingParameterError < Exception; end

  protected

  def rescue_action_locally( exception )
    rescue_action_in_public( exception )
  end

  def rescue_action_in_public(exception)
    @message = exception.message
    if request.xhr?
      render :template => "error", :layout => false, :status => 400
    else
      render :template => 'error', :layout => "application", :status => 400
    end
  end

  def set_language
    if cookies[:lang]
      @lang = cookies[:lang]
    elsif params[:lang]
      @lang = params[:lang][0]
    end
    @lang.gsub!(/_/, '-') if @lang
    if !@lang || !LANGUAGES.include?( @lang )
      if !request.compatible_language_from(LANGUAGES).blank?
        @lang = request.compatible_language_from(LANGUAGES).dup
      else
        @lang = "en"
      end
    end
    @lang.gsub!(/-/, '_')
    GetText.locale = @lang
  end


  def set_distributions
    @distributions = Rails.cache.fetch('distributions', :expires_in => 120.minutes) do
      load_distributions
    end
  end


  # load available distributions
  def load_distributions
    @distributions = Array.new
    begin
      response = get_from_api("distributions")
      doc = REXML::Document.new response.body
      doc.elements.each("distributions/distribution") { |element|
        dist = [element.elements['name'].text, element.elements['project'].text]
        @distributions << dist
      }
      @distributions << ["ALL Distributions", 'ALL']
    rescue Exception => e
      logger.error "Error while loading distributions: " + e.to_s
      @distributions = nil
    end
    return @distributions
  end

  # special version of render json with JSONP capabilities (only needed for rails < 3.0)
  def render_json(json, options = {})
    callback, variable = params[:callback], params[:variable]
    response = begin
      if callback && variable
        "var #{variable} = #{json};\n#{callback}(#{variable});"
      elsif variable
        "var #{variable} = #{json};"
      elsif callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response}.merge(options))
  end

  def required_parameters(*parameters)
    parameters.each do |parameter|
      unless params.include? parameter.to_s
        raise MissingParameterError, "Required Parameter #{parameter} missing"
      end
    end
  end

  private

  def get_from_api(path)
    uri_str = "#{API_HOST}/#{path}".gsub(' ', '%20')
    uri = URI.parse(uri_str)
    logger.debug "Loading from api: #{uri_str}"
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      if  uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      api_user = API_USERNAME if defined? API_USERNAME
      api_pass = API_PASSWORD if defined? API_PASSWORD
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
      raise "Error connecting to #{uri_str}: #{e.to_s}"
      return nil
    end
  end

end
