# frozen_string_literal: true

require 'open-uri'
require 'open_uri_redirections'
require 'zlib'

class Appdata
  attr_reader :data

  def initialize(distribution)
    @distribution = distribution
    @data = load_appdata
  end

  private

  def load_appdata
    data = { apps: [], categories: Set.new }
    %w[oss non-oss].each do |flavour|
      xml = load_xml(flavour)
      data[:apps].concat(parse_appdata_apps(xml))
      data[:categories].merge(parse_appdata_categories(xml))
    end
    data
  end

  def load_xml(flavour)
    baseurl = if @distribution == 'tumbleweed'
                "https://download.opensuse.org/tumbleweed/repo/#{flavour}/"
              else
                "https://download.opensuse.org/distribution/#{@distribution}/repo/#{flavour}/"
              end

    index_url = "#{baseurl}/repodata/repomd.xml"
    repomd = Nokogiri::XML(URI.open(index_url)).remove_namespaces!
    href = repomd.xpath('/repomd/data[@type="appdata"]/location').attr('href').text
    appdata_url = baseurl + href
    Nokogiri::XML(Zlib::GzipReader.new(URI.open(appdata_url, allow_redirections: :all)))
  # Broad except, could be network connection, missing 'href' attribute
  rescue StandardError => e
    Rails.logger.error("Error: #{e} -- appdata_url=#{appdata_url}")
    Nokogiri::XML('<?xml version="1.0" encoding="UTF-8"?><components origin="appdata" version="0.8"></components>')
  end

  def parse_appdata_apps(xml)
    apps = []
    xml.xpath('/components/component').each do |app|
      appdata = {}
      # Filter translated versions of name and summary out
      appdata[:name] = app.xpath('name[not(@xml:lang)]').text
      appdata[:summary] = app.xpath('summary[not(@xml:lang)]').text
      appdata[:pkgname] = app.xpath('pkgname').text
      appdata[:categories] = app.xpath('categories/category').map(&:text).reject { |c| c.match(/^X-/) }.uniq
      appdata[:id] = app.xpath('id').text
      appdata[:homepage] = app.xpath('url').text
      appdata[:screenshots] = app.xpath('screenshots/screenshot/image').map(&:text)
      apps << appdata
    end
    apps
  end

  def parse_appdata_categories(xml)
    xml.xpath('/components/component/categories/category')
       .map(&:text).reject { |c| c.match(/^X-/) }.uniq
  end
end
