# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'api_connect'
require 'net/https'

class ApplicationController < ActionController::Base

  before_filter :set_language
  before_filter :set_distributions
  before_filter :set_baseproject

  helper :all # include all helpers, all the time
  require "rexml/document"

  class MissingParameterError < Exception; end

  protected

  rescue_from Exception do |exception|
    logger.error "Exception: #{exception.class}: #{exception.message}"
    @message = exception.message
    layout = request.xhr? ? false : "application"
    case exception
    when Seeker::InvalidSearchTerm
    when ApiConnect::Error
    when ApplicationController::MissingParameterError
    when Timeout::Error
    else
      logger.error exception.backtrace.join("\n")
      notify_hoptoad(exception)
    end
    render template: 'error', formats: [:html], layout: layout, status: 400
  end

  def set_language
    set_gettext_locale
    unless LANGUAGES.include? FastGettext.locale
      params[:locale] = FastGettext.default_locale
      set_gettext_locale
    end
    @lang = FastGettext.locale
  end


  def set_distributions
    @distributions = Rails.cache.fetch('distributions', expires_in: 120.minutes) do
      load_distributions
    end
    raise ApiConnect::Error.new(_("OBS Backend not available")) if @distributions.nil?
  end

  def set_baseproject
    unless ( @distributions.blank? || @distributions.select{|d| d[:project] == cookies[:search_baseproject]}.blank? )
      @baseproject = cookies[:search_baseproject]
    end
  end


  # load available distributions
  def load_distributions
    logger.debug "Loading distributions"
    @distributions = Array.new
    begin
      response = ApiConnect::get("public/distributions")
      doc = REXML::Document.new response.body
      doc.elements.each("distributions/distribution") { |element|
        dist = Hash[name: element.elements['name'].text, project: element.elements['project'].text,
          reponame: element.elements['reponame'].text, repository: element.elements['repository'].text,
          icon: element.elements['icon'].attributes["url"], dist_id: element.attributes['id'].sub(".", "") ]
        @distributions << dist
        logger.debug "Added Distribution: #{dist[:name]}"
      }
      @distributions << Hash[name: "ALL Distributions", project: 'ALL' ]
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
    render({content_type: "application/javascript", body: response}.merge(options))
  end

  def required_parameters(*parameters)
    parameters.each do |parameter|
      unless params.include? parameter.to_s
        raise MissingParameterError, "Required Parameter #{parameter} missing"
      end
    end
  end


  def valid_package_name?(name)
    name =~ /^[[:alnum:]][-+\w\.:\@]*$/
  end

  def valid_pattern_name?(name)
    name =~ /^[[:alnum:]][-_+\w\.:]*$/
  end

  def valid_project_name?(name)
    name =~ /^[[:alnum:]][-+\w.:]+$/
  end


  def set_search_options
    @search_term = params[:q] || ""
    @baseproject = params[:baseproject] unless @distributions.select{|d| d[:project] == params[:baseproject]}.blank?
    @search_devel = cookies[:search_devel] unless cookies[:search_devel].blank?
    @search_devel = params[:search_devel] unless params[:search_devel].blank?
    @search_unsupported = cookies[:search_unsupported] unless cookies[:search_unsupported].blank?
    @search_unsupported = params[:search_unsupported] unless params[:search_unsupported].blank?
    # FIXME: remove @search_unsupported when redesigning search options
    @search_unsupported = "true"
    @search_devel = ( @search_devel == "true" ? true : false )
    @search_project = params[:search_project]
    @search_unsupported = ( @search_unsupported == "true" ? true : false )
    @exclude_debug = @search_devel ? false : true
    @exclude_filter = @search_unsupported ? nil : 'home:'
    cookies[:search_devel] = { value: @search_devel, expires: 1.year.from_now }
    cookies[:search_unsupported] = { value: @search_unsupported, expires: 1.year.from_now }
    cookies[:search_baseproject] = { value: @baseproject, expires: 1.year.from_now }
  end


  # TODO: atm obs only offers appdata for Factory
  def prepare_appdata
    @appdata =  Rails.cache.fetch("appdata", expires_in: 12.hours) do
        Appdata.get "factory"
    end
  end

  private

  def set_beta_warning
    flash.now[:info] = "This is a beta version of the new app browser, part of " +
                       "the <a href='https://trello.com/board/appstream/4f156e1c9ce0824a2e1b8831'>current boosters sprint</a>!"
  end

end
