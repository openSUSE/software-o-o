# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'net/https'

class ApplicationController < ActionController::Base

  before_filter :set_language
  before_filter :set_distributions
  before_filter :set_baseproject
  
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

  def set_baseproject
    @baseproject = cookies[:search_baseproject] unless @distributions.select{|d| d[:project] == cookies[:search_baseproject]}.blank?
  end


  # load available distributions
  def load_distributions
    logger.debug "Loading distributions"
    @distributions = Array.new
    begin
      response = ApiConnect::get("distributions")
      doc = REXML::Document.new response.body
      doc.elements.each("distributions/distribution") { |element|
        dist = Hash[:name => element.elements['name'].text, :project => element.elements['project'].text,
          :reponame => element.elements['reponame'].text, :repository => element.elements['repository'].text, 
          :icon => element.elements['icon'].attributes["url"], :dist_id => element.attributes['id'].sub(".", "") ]
        @distributions << dist
        logger.debug "Added Distribution: #{dist}"
      }
      @distributions << Hash[:name => "ALL Distributions", :project => 'ALL' ]
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
  

  def valid_package_name? name
    name =~ /^[[:alnum:]][-_+\w\.:]*$/
  end

  def valid_pattern_name? name
    name =~ /^[[:alnum:]][-_+\w\.:]*$/
  end

  def valid_project_name? name
    name =~ /^[[:alnum:]][-+\w.:]+$/
  end


  def set_search_options
    @search_term = CGI::unescape( params[:q] || "" )
    @baseproject = params[:baseproject] unless @distributions.select{|d| d[:project] == params[:baseproject]}.blank?
    @search_devel = cookies[:search_devel] unless cookies[:search_devel].blank?
    @search_devel = params[:search_devel] unless params[:search_devel].blank?
    @search_unsupported = cookies[:search_unsupported] unless cookies[:search_unsupported] .blank?
    @search_unsupported = params[:search_unsupported] unless params[:search_unsupported].blank?
    @search_devel = ( @search_devel == "true" ? true : false )
    @search_unsupported = ( @search_unsupported == "true" ? true : false )
    @exclude_debug = @search_devel ? false : true
    if ( @baseproject != "ALL" && !@search_unsupported)
      @search_project = @baseproject
    elsif ( !@search_unsupported )
      @exclude_filter = 'home:'
    end
    cookies[:search_devel] = { :value => @search_devel, :expires => 1.year.from_now }
    cookies[:search_unsupported] = { :value => @search_unsupported, :expires => 1.year.from_now }
    cookies[:search_baseproject] = { :value => @baseproject, :expires => 1.year.from_now }
  end

  private

  def set_beta_warning
    flash.now[:info] = "This is a beta version of the new package search, part of " +
      "the <a href='https://trello.com/board/appstream/4f156e1c9ce0824a2e1b8831'>current boosters sprint</a>!"
  end

end
