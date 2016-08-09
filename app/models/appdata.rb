require 'open-uri'

class Appdata

  def self.get(dist="factory")
    data = Hash.new
    xml = Appdata.get_distribution dist, "oss"
    data = add_appdata data, xml
#    xml = Appdata.get_distribution dist, "non-oss"
#    data = add_appdata data, xml
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
      appdata[:categories] = app.xpath('categories/category').map{|c| c.text}.reject{|c| c.match(/^X-/)}.uniq
      appdata[:homepage] = app.xpath('url').text
      appdata[:screenshots] = app.xpath('screenshots/screenshot/image').map{|s| s.text}
      data[:apps] << appdata
    end
    data[:categories] += xml.xpath("/components/component/categories/category")
                            .map{|cat| cat.text}.reject{|c| c.match(/^X-/)}.uniq
    data
  end


  # Get the appdata xml for a distribution
  def self.get_distribution(dist="factory", flavour="oss")
    if dist == "factory"
      appdata_regex = /appdata-\S{32}.xml.gz/
      tumbleweed_contents = open("http://download.opensuse.org/tumbleweed/repo/#{flavour}/content") {|f| f.read }
      appdata_filename = tumbleweed_contents.match(appdata_regex)
      appdata_url = "http://download.opensuse.org/tumbleweed/repo/#{flavour}/suse/setup/descr/#{appdata_filename}"
    else
      appdata_url = "http://download.opensuse.org/distribution/#{dist}/repo/#{flavour}/suse/setup/descr/appdata.xml.gz"
    end
    begin
      appdata = ApiConnect::get appdata_url
    rescue
      # never ever die when remote is not working or file is not there
    end
    zipfilename = File.join( Rails.root.join('tmp'), "appdata-" + dist + ".xml.gz" )
    filename = File.join( Rails.root.join('tmp'), "appdata-" + dist + ".xml" )
    File.open(zipfilename, "w+", encoding: 'ascii-8bit') do |f|
      f.write(appdata.body) if appdata
    end
    `gunzip -f #{zipfilename}`
    xmlfile = File.open(filename)
    doc = Nokogiri::XML(xmlfile)
    xmlfile.close
    doc
  end


end
