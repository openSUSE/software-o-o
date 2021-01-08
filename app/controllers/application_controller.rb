# frozen_string_literal: true

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'api_connect'
require 'net/https'

class ApplicationController < ActionController::Base
  before_action :validate_configuration
  before_action :set_language
  before_action :set_external_urls

  helper :all # include all helpers, all the time
  require 'rexml/document'

  class MissingParameterError < RuntimeError; end

  protected

  EXCEPTIONS_TO_IGNORE = [OBS::InvalidSearchTerm,
                          ApiConnect::Error,
                          ApplicationController::MissingParameterError,
                          Timeout::Error].freeze

  rescue_from Exception do |exception|
    logger.error "Exception: #{exception.class}: #{exception.message}"
    @message = exception.message
    layout = request.xhr? ? false : 'application'
    logger.error exception.backtrace.join("\n") unless EXCEPTIONS_TO_IGNORE.include? exception
    render template: 'error', formats: [:html], layout: layout, status: 400
  end

  def validate_configuration
    config = Rails.configuration.x
    layout = request.xhr? ? false : 'application'

    if config.api_username.blank? && config.opensuse_cookie.blank?
      @message = _('The authentication to the OBS API has not been configured correctly.')
      render template: 'error', formats: [:html], layout: layout, status: 503
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

  # special version of render json with JSONP capabilities (only needed for rails < 3.0)
  def render_json(json, options = {})
    callback = params[:callback]
    variable = params[:variable]
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
    render({ content_type: 'application/javascript', body: response }.merge(options))
  end

  def valid_package_name?(name)
    name =~ /^[[:alnum:]][-+~\w.:@]*$/
  end

  def valid_pattern_name?(name)
    name =~ /^[[:alnum:]][-_+\w.:]*$/
  end

  def valid_project_name?(name)
    name =~ /^[[:alnum:]][-+\w.:]+$/
  end

  def prepare_appdata
    @appdata = case @baseproject
               when 'ALL'
                 tw = tumbleweed_appdata
                 stable = leap_appdata(@stable_version)
                 testing = @testing_version ? leap_appdata(@testing_version) : {}
                 legacy = @legacy_release ? leap_appdata(@legacy_release) : {}
                 # Overwriting entries is okay, appdata is not used for
                 # installation when @baseproject == 'ALL'
                 tw.merge(stable).merge(testing).merge(legacy)
               when 'openSUSE:Factory'
                 tumbleweed_appdata
               when "openSUSE:Leap:#{@stable_version}"
                 leap_appdata(@stable_version)
               when "openSUSE:Leap:#{@testing_version}"
                 leap_appdata(@testing_version)
               when "openSUSE:Leap:#{@legacy_release}"
                 leap_appdata(@legacy_release)
               else
                 { apps: [], categories: Set.new }
               end
  end

  private

  def tumbleweed_appdata
    Rails.cache.fetch('appdata/tumbleweed', expires_in: 12.hours) do
      Appdata.new('tumbleweed').data
    end
  end

  def leap_appdata(version)
    Rails.cache.fetch("appdata/leap#{version}", expires_in: 12.hours) do
      Appdata.new("leap/#{version}").data
    end
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
