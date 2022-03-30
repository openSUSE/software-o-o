# frozen_string_literal: true

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'api_connect'
require 'net/https'
require 'json'

class ApplicationController < ActionController::Base
  before_action :validate_configuration
  before_action :set_language

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

  RELEASES_FILE = 'https://get.opensuse.org/api/v0/distributions.json'

  def load_releases
    Rails.cache.fetch('software-o-o/releases', expires_in: 10.minutes) do
      JSON.parse(URI.parse(RELEASES_FILE).open.read)['Leap'].sort_by { |r| -r['upgrade-weight'] }
    rescue StandardError => e
      Rails.logger.error "Error while parsing releases entry in #{RELEASES_FILE}: #{e}"
      next
    end
  rescue StandardError => e
    Rails.logger.error "Error while parsing releases file #{RELEASES_FILE}: #{e}"
    raise e
  end

  def set_releases_parameters
    @stable_version = nil
    @testing_version = nil
    @testing_state = nil
    @legacy_release = nil

    # look for most current release
    versions = load_releases
    unless versions.empty?
      if versions[0]['state'] == 'Stable'
        @stable_version = versions[0]['version'].to_s
        @legacy_release = versions[1]['version'].to_s
      else
        @testing_version = versions[0]['version'].to_s
        @testing_state = versions[0]['state'].to_s
        @stable_version = versions[1]['version'].to_s
        @legacy_release = versions[2]['version'].to_s
      end
    end
  end

  def valid_package_name?(name)
    name =~ /^[[:alnum:]][-+~\w.:@]*$/
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
end
