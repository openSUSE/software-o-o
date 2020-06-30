# frozen_string_literal: true

require 'open-uri'
require 'open_uri_redirections'
require 'zlib'

class Appdata
  def self.get(dist = 'factory')
    data = {}
    xml = Appdata.get_distribution(dist, 'oss')
    data = add_appdata(data, xml)
    xml = Appdata.get_distribution(dist, 'non-oss')
    data = add_appdata(data, xml)
    data
  end

  private

  def self.add_appdata(data, xml)
    data[:apps] ||= []
    data[:categories] ||= []
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
      data[:apps] << appdata
    end
    data[:categories] += xml.xpath('/components/component/categories/category')
                            .map(&:text).reject { |c| c.match(/^X-/) }.uniq
    data
  end

  # Get the appdata xml for a distribution
  def self.get_distribution(dist = 'factory', flavour = 'oss')
    baseurl = if dist == 'factory'
                "https://download.opensuse.org/tumbleweed/repo/#{flavour}/"
              else
                "https://download.opensuse.org/distribution/#{dist}/repo/#{flavour}/"
              end

    index_url = "#{baseurl}/repodata/repomd.xml"
    repomd = Nokogiri::XML(open(index_url)).remove_namespaces!
    href = repomd.xpath('/repomd/data[@type="appdata"]/location').attr('href').text
    appdata_url = baseurl + href
    Nokogiri::XML(Zlib::GzipReader.new(open(appdata_url, allow_redirections: :all)))
  # Broad except, could be network connection, missing 'href' attribute
  rescue StandardError => e
    Rails.logger.error("Error: #{e} -- appdata_url=#{appdata_url}")
    Nokogiri::XML('<?xml version="1.0" encoding="UTF-8"?><components origin="appdata" version="0.8"></components>')
  end
end
