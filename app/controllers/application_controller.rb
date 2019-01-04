# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'api_connect'
require 'net/https'

class ApplicationController < ActionController::Base
  before_action :validate_configuration
  before_action :set_language
  before_action :set_external_urls
  before_action :set_releases_parameters
  # depends on releases
  before_action :set_baseproject

  helper :all # include all helpers, all the time
  require "rexml/document"

  class MissingParameterError < Exception; end

  protected

  rescue_from Exception do |exception|
    logger.error "Exception: #{exception.class}: #{exception.message}"
    @message = exception.message
    layout = request.xhr? ? false : "application"
    case exception
    when OBS::InvalidSearchTerm
    when ApiConnect::Error
    when ApplicationController::MissingParameterError
    when Timeout::Error
    else
      logger.error exception.backtrace.join("\n")
    end
    render :template => 'error', :formats => [:html], :layout => layout, :status => 400
  end

  def validate_configuration
    config = Rails.configuration.x
    layout = request.xhr? ? false : "application"

    if config.api_username.blank? && config.opensuse_cookie.blank?
      @message = _("The authentication to the OBS API has not been configured correctly.")
      render :template => 'error', :formats => [:html], :layout => layout, :status => 503
    end
  end

  def set_language
    set_gettext_locale
    requested_locale = FastGettext.locale
    # if we don't have translations for the requested locale, try
    # the short form without underscore
    unless LANGUAGES.include? requested_locale
      requested_locale = requested_locale.split('_').first
      params[:locale] = LANGUAGES.include?(requested_locale) ? requested_locale : 'en'
      set_gettext_locale
    end
    @lang = FastGettext.locale
  end

  RELEASES_FILE = Rails.root.join('config', 'releases.yml').freeze

  def load_releases
    Rails.cache.fetch('software-o-o/releases', expires_in: 10.minutes) do
      begin
        YAML.load_file(RELEASES_FILE).map do |release|
          release['from'] = Time.parse(release['from'])
          release
        end
      rescue => e
        Rails.logger.error "Error while parsing releases entry in #{RELEASES_FILE}: #{e}"
        next
      end.compact.sort_by do |release|
        -release['from'].to_i
      end
    end
  rescue => e
    Rails.logger.error "Error while parsing releases file #{RELEASES_FILE}: #{e}"
    raise e
  end

  def set_releases_parameters
    @stable_version = nil
    @testing_version = nil
    @testing_state = nil
    @legacy_release = nil

    # look for most current release
    releases = load_releases
    current = unless releases.empty?
                now = Time.now
                # drop all upcoming releases
                upcoming = releases.reject do |release|
                  release['from'] > now
                end

                upcoming.empty? ? releases.last : upcoming.first
              end

    return unless current
    @stable_version = current['stable_version']
    @testing_version = current['testing_version']
    @testing_state = current['testing_state']
    @legacy_release = current['legacy_version']
  end

  def set_baseproject
    unless @distributions.blank? || @distributions.select { |d| d[:project] == cookies[:baseproject] }.blank?
      @baseproject = cookies[:baseproject]
    end
    @baseproject = "openSUSE:Leap:#{@stable_version}" if @baseproject.blank?
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
    render({ :content_type => "application/javascript", :body => response }.merge(options))
  end

  def required_parameters(*parameters)
    parameters.each do |parameter|
      unless params.include? parameter.to_s
        raise MissingParameterError, "Required Parameter #{parameter} missing"
      end
    end
  end

  def valid_package_name? name
    name =~ /^[[:alnum:]][-+\w\.:\@]*$/
  end

  def valid_pattern_name? name
    name =~ /^[[:alnum:]][-_+\w\.:]*$/
  end

  def valid_project_name? name
    name =~ /^[[:alnum:]][-+\w.:]+$/
  end

  # TODO: atm obs only offers appdata for Factory
  def prepare_appdata
    @appdata = Rails.cache.fetch("appdata", :expires_in => 12.hours) do
      Appdata.get "factory"
    end
  end

  private

  def set_beta_warning
    flash.now[:info] = "This is a beta version of the new app browser, part of " +
                       "the <a href='https://trello.com/board/appstream/4f156e1c9ce0824a2e1b8831'>current boosters sprint</a>!"
  end

  # set wiki and forum urls, which are different for each language
  def set_external_urls
    @wiki_url = case @lang
                when 'zh_CN'
                  'https://zh.opensuse.org/'
                when 'zh_TW'
                  'https://zh-tw.opensuse.org/'
                when 'pt_BR'
                  'https://pt.opensuse.org/'
                else
                  "https://#{@lang}.opensuse.org/"
                end

    @forum_url =  case @lang
                  when 'zh_CN'
                    'https://forum.suse.org.cn/'
                  else
                    'https://forums.opensuse.org/'
                  end
  end
end
