require 'open-uri'
require 'zlib'

class Appdata
  def self.get(dist = 'factory')
    data = Hash.new
    xml = Appdata.get_distribution(dist, 'oss')
    data = add_appdata(data, xml)
    xml = Appdata.get_distribution(dist, 'non-oss')
    data = add_appdata(data, xml)
    data
  end

  private

  def self.add_appdata(data, xml)
    data[:apps] = Array.new unless data[:apps]
    data[:categories] = Array.new unless data[:categories]
    xml.xpath("/components/component").each do |app|
      appdata = Hash.new
      # Filter translated versions of name and summary out
      appdata[:name] = app.xpath('name[not(@xml:lang)]').text
      appdata[:summary] = app.xpath('summary[not(@xml:lang)]').text
      appdata[:pkgname] = app.xpath('pkgname').text
      appdata[:categories] = app.xpath('categories/category').map {|c| c.text}.reject {|c| c.match(/^X-/)}.uniq
      appdata[:homepage] = app.xpath('url').text
      appdata[:screenshots] = app.xpath('screenshots/screenshot/image').map {|s| s.text}
      data[:apps] << appdata
    end
    data[:categories] += xml.xpath("/components/component/categories/category")
                            .map {|cat| cat.text}.reject {|c| c.match(/^X-/)}.uniq
    data
  end

  # Get the appdata xml for a distribution
  def self.get_distribution(dist = 'factory', flavour = 'oss')
    appdata_url = case dist
                  when "factory"
                    index_url = "http://download.opensuse.org/tumbleweed/repo/#{flavour}/repodata/repomd.xml"
                    repomd = Nokogiri::XML(open(index_url))
                    repomd.remove_namespaces!
                    href = repomd.xpath('/repomd/data[@type="appdata"]/location').attr('href').text
                    "http://download.opensuse.org/tumbleweed/repo/#{flavour}/#{href}"
                  else
                    "http://download.opensuse.org/distribution/#{dist}/repo/#{flavour}/suse/setup/descr/appdata.xml.gz"
                  end
    begin
      Nokogiri::XML(Zlib::GzipReader.new(open(appdata_url)))
    rescue StandardError => e
      Rails.logger.error e
      Rails.logger.error "Can't retrieve appdata from: '#{appdata_url}'"
      Nokogiri::XML('<?xml version="1.0" encoding="UTF-8"?><components origin="appdata" version="0.8"></components>')
    end
  end
end
