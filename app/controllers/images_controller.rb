require 'open-uri'
require 'nokogiri'

# Controller for /images.xml
class ImagesController < ApplicationController

  attr_accessor :base_url

  def initialize
    @base_url = "http://download.opensuse.org"
  end

  class MetadataError < RuntimeError; end

  # GET /images.xml
  def images; end

  # Returns the first capture of regex applied to the file name of URL's redirection target
  def get_version(url, regex)
    abs_url = @base_url + url
    Rails.cache.fetch("/build_number/#{abs_url}", expires_in: 10.minutes) do
      begin
        meta = meta_file(abs_url)
        name_elem = meta.xpath("//m:metalink//m:file//@name", 'm' => 'urn:ietf:params:xml:ns:metalink').to_s
        matches = regex.match(name_elem.to_s)
        matches[1]
      rescue OpenURI::HTTPError, RuntimeError => e
        filename = File.basename(URI.parse(abs_url).path)
        raise MetadataError, "Could not get version of #{filename}: #{e}"
      end
    end
  end

  # Returns a string containing a XML <image> element with all necessary content for url and name
  def image_element(url, name)
    abs_url = @base_url + url
    size = content_size(abs_url)

    ret  = "<image url=#{abs_url.encode(xml: :attr)} name=#{name.encode(xml: :attr)} size=\"#{size}\">\n"
    ret += "<checksum type=\"sha256\" disposition=#{(abs_url + '.sha256').encode(xml: :attr)}/>\n"
    ret += "</image>"
    ret.html_safe
  end

  helper_method :get_version
  helper_method :image_element

  protected

  # Returns the content size of url
  def content_size(url)
    Rails.cache.fetch("/content_size/#{url}", expires_in: 10.minutes) do
      begin
        meta = meta_file(url)
        size_text = meta.xpath("//m:metalink//m:file//m:size[1]//text()", 'm' => 'urn:ietf:params:xml:ns:metalink')
        size = Integer(size_text.to_s)
        size
      rescue OpenURI::HTTPError, RuntimeError
        # This is actualy gibibytes, not gigabytes
        return 5.gigabytes
      end
    end
  end

  # Returns a Nokogiri XML document of the mirrorbrain metadata for url
  def meta_file(url)
    Nokogiri::XML(open(url + '.meta4'))
  end
end
