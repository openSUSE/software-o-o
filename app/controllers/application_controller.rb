# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :set_language
  before_filter :set_distributions
  
  helper :all # include all helpers, all the time
  require "rexml/document"

  init_gettext('software')

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
    uri = URI.parse("http://#{API_HOST}/distributions")
    request = Net::HTTP::Get.new(uri.path)
    logger.debug "Loading distributions from #{uri}"
    @distributions = Array.new
    begin
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.read_timeout = 30
        response = http.request(request)
        unless( response.kind_of? Net::HTTPSuccess )
          logger.error "Cannot load distributions: '#{response.code}', message: \n#{response.body}"
        else
          doc = REXML::Document.new response.body
          doc.elements.each("distributions/distribution") { |element|
            dist = [element.elements['name'].text, element.elements['project'].text]
            @distributions << dist
          }
        end
      end
      @distributions << ["ALL Distributions", 'ALL']
      return @distributions
    rescue Exception => e
      logger.error "Error while loading distributions from '#{uri}': " + e.to_s
    end
    return nil
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


end
