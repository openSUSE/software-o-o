require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'nokogiri'
require 'faker'

require 'capybara/rails'
class ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]
end

require 'webmock/minitest'
# Prevent webmock to prevent capybara to connect to localhost
WebMock.disable_net_connect!(:allow_localhost => true)

class ActiveSupport::TestCase
  # Helper to associate queries to OBS with the corresponding file in
  # test/support
  def stub_content(url, what = {})
    what = { body: what } if what.is_a?(String)
    stub = stub_request(:get, url).to_return(what)
    stub.with(basic_auth: ['test', 'test']) if url =~ /^api/
    yield stub if block_given?
  end

  def stub_remote_file(url, filename, &block)
    stub_content(url, body: File.read(Rails.root.join('test', 'support', filename)), &block)
  end

  # Stubs a search for a term and a project with random data
  # opts :matches sets the number of results, otherwise random
  def stub_search_random(term, baseproject, opts = {})
    matches = (opts[:matches] || (1..10).to_a.sample).to_i

    # rubocop:disable Metrics/BlockLength
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.collection(matches: matches) do
        matches.times.each do
          pkg = term
          bin = "#{pkg}-#{Faker::Lorem.unique.word}"
          user = Faker::Internet.user_name
          ver = "#{(1..10).to_a.sample}.#{(1..10).to_a.sample}"
          rel = "#{(1..10).to_a.sample}.#{(1..10).to_a.sample}"
          arch = ['x86_64', 'noarch'].sample
          file = "#{bin}-#{ver}-#{rel}.#{arch}.rpm"
          repo = baseproject.tr(':', '_')
          project = "home:#{user}"
          filepath = "#{project.gsub(':', ':/')}/#{repo}/#{arch}/#{file}"
          xml.binary do
            xml.name bin
            xml.project project
            xml.package pkg
            xml.repository repo
            xml.version ver
            xml.release rel
            xml.arch arch
            xml.filename file
            xml.filepath filepath
            xml.baseproject project
            xml.type 'rpm'
          end
          builder_fileinfo = Nokogiri::XML::Builder.new do |info_xml|
            info_xml.fileinfo(filename: file) do
              info_xml.name bin
              info_xml.version ver
              info_xml.release rel
              info_xml.arch arch
              info_xml.summary Faker::Lorem.sentence
              info_xml.description Faker::Lorem.paragraph
              info_xml.size 10_000
              info_xml.mtime Time.now.to_i
            end
          end
          stub_content("https://api.opensuse.org/published/#{project}/#{repo}/#{arch}/#{file}?view=fileinfo", builder_fileinfo.to_xml)
        end
      end
    end
    # rubocop:enable Metrics/BlockLength

    xpath = %{
    contains-ic(@name, '#{term}') and path/project='#{baseproject}' and
      not(contains-ic(@name, '-debuginfo')) and not(contains-ic(@name, '-debugsource')) and
      not(contains-ic(@name, '-devel')) and not(contains-ic(@name, '-lang'))
    }.squish
    stub_content("https://api.opensuse.org/search/published/binary/id?match=#{URI.escape(xpath)}", builder.to_xml)
  end

  APPDATA_CHECKSUM = "a63a63d45b002d5ff8f37c09315cda2c4a9d89ae698f56e95b92f1274332c157".freeze
  APPDATA_NON_OSS_CHECKSUM = "be1fe70d7bf5a73e1e0e9e4a8bd6ea84c752bef85b02b2e7ea97cb4ac232d353".freeze

  setup do
    # stub OBS using WebMock
    stub_remote_file("https://api.opensuse.org/public/distributions?", "distributions.xml")
    stub_remote_file("https://download.opensuse.org/tumbleweed/repo/oss/repodata/repomd.xml", "repomd.xml")
    stub_remote_file("https://download.opensuse.org/tumbleweed/repo/non-oss/repodata/repomd.xml", "repomd-non-oss.xml")

    stub_remote_file("https://download.opensuse.org/tumbleweed/repo/oss/repodata/#{APPDATA_CHECKSUM}-appdata.xml.gz", "appdata.xml.gz")
    stub_remote_file("https://download.opensuse.org/tumbleweed/repo/non-oss/repodata/#{APPDATA_NON_OSS_CHECKSUM}-appdata.xml.gz", "appdata-non-oss.xml.gz")
    stub_remote_file("https://api.opensuse.org/search/published/binary/id?match=@name%20=%20'pidgin'%20", "pidgin.xml")
    stub_remote_file("https://api.opensuse.org/published/openSUSE:13.1/standard/i586/pidgin-2.10.7-4.1.3.i586.rpm?view=fileinfo", "pidgin-fileinfo.xml")
    stub_content("https://api.opensuse.org/source/openSUSE:13.1/_attribute/OBS:QualityCategory", "<attributes/>")
  end

  teardown do
    WebMock.reset!
  end
end
