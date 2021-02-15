# frozen_string_literal: true

require 'api_connect'

class OBSError < StandardError; end

# Handle connection to OBS
class OBSController < ApplicationController
  before_action :set_distributions
  before_action :set_releases_parameters
  before_action :set_baseproject

  private

  def set_distributions
    @distributions = Rails.cache.fetch('distributions', expires_in: 120.minutes) do
      load_distributions
    end
  rescue OBSError
    @distributions = nil
    @hide_search_box = true
    flash[:error] = 'Connection to OBS is unavailable. Functionality of this site is limited.'
  end

  def load_distributions
    logger.debug 'Loading distributions'
    loaded_distros = []
    begin
      response = ApiConnect.get('public/distributions')
      doc = REXML::Document.new response.body
      doc.elements.each('distributions/distribution') do |element|
        loaded_distros << parse_distribution(element)
      end
      loaded_distros.unshift(Hash[name: 'ALL Distributions', project: 'ALL'])
    rescue Exception => e
      logger.error 'Error while loading distributions: ' + e.to_s
      raise OBSError.new, _('OBS Backend not available')
    end
    loaded_distros
  end

  def parse_distribution(element)
    dist = {
      name: element.elements['name'].text,
      project: element.elements['project'].text,
      reponame: element.elements['reponame'].text,
      repository: element.elements['repository'].text,
      dist_id: element.attributes['id'].sub('.', '')
    }
    logger.debug "Added Distribution: #{dist[:name]}"
    dist
  end

  def set_search_options
    @search_term = params[:q] || ''
    @search_devel = (cookies[:search_devel] == 'true')
    @search_lang = (cookies[:search_lang] == 'true')
    @search_debug = (cookies[:search_debug] == 'true')
  end

  def filter_packages
    # remove maintenance projects, they are not meant for end users
    @packages.reject! { |p| p.project.match(/openSUSE:Maintenance:/) }
    @packages.reject! { |p| p.project == 'openSUSE:Factory:Rebuild' }
    @packages.reject! { |p| p.project.start_with?('openSUSE:Factory:Staging') }

    # only show packages
    @packages.reject! { |p| p.type == 'ymp' }

    @packages.reject! { |p| /-devel/i.match?(p.name) } unless @search_devel

    unless @search_lang
      @packages.reject! { |p| p.name.end_with?('-lang') || p.name.include?('-translations-') || p.name.include?('-l10n-') }
    end

    @packages.reject! { |p| p.name.end_with?('-buildsymbols', '-debuginfo', '-debugsource') } unless @search_debug

    # filter out ports for different arch
    if @baseproject.end_with?('ARM')
      @packages.select! { |p| p.project.include?('ARM') || p.repository.include?('ARM') }
    elsif @baseproject.end_with?('PowerPC')
      @packages.select! { |p| p.project.include?('PowerPC') || p.repository.include?('PowerPC') }
    else # x86
      @packages.reject! do |p|
        p.repository.end_with?('_ARM', '_PowerPC', '_zSystems') || p.repository == 'ports' ||
          p.project.include?('ARM') || p.project.include?('PowerPC') || p.project.include?('zSystems')
      end
    end
  end

  def set_baseproject
    default_baseproject = "openSUSE:Leap:#{@stable_version}"

    if params[:baseproject].present? && valid_baseproject?(params[:baseproject])
      @baseproject = params[:baseproject]
      update_baseproject_cookie(params[:baseproject])
    elsif cookies[:baseproject].present? && valid_baseproject?(cookies[:baseproject])
      @baseproject = cookies[:baseproject]
    end
    @baseproject = default_baseproject unless @baseproject.present?
  end

  def valid_baseproject?(project)
    @distributions.present? && @distributions.select { |d| d[:project] == project }.present?
  end

  def update_baseproject_cookie(project)
    cookies.delete :baseproject
    cookies.permanent[:baseproject] = project
  end
end
