class Appdata < ActiveXML::Base

  def self.get dist="factory"
    data = Hash.new
    data[:apps] = Array.new
    # TODO: automatically load non-oss, too
    xml = Appdata.get_distribution dist, "oss"
    xml.xpath("/applications/application").each do |app|
      appdata = Hash.new
      appdata[:name] = app.xpath('name').text
      appdata[:pkgname] = app.xpath('pkgname').text
      appdata[:categories] = app.xpath('appcategories/appcategory').map{|c| c.text}.reject{|c| c.match(/^X-/)}.uniq
      appdata[:homepage] = app.xpath('url').text
      appdata[:summary] = app.xpath('summary').text
      data[:apps] << appdata
    end
    data[:categories] = xml.xpath("/applications/application/appcategories/appcategory").
      map{|cat| cat.text}.reject{|c| c.match(/^X-/)}.uniq
    data
  end


  private

  # Get the appdata xml for a distribution
  # TODO: atm obs only offers appdata for Factory
  def self.get_distribution dist="factory", flavour="oss"
    if dist == "factory"
      appdata_url = "http://download.opensuse.org/factory/repo/#{flavour}/suse/setup/descr/appdata.xml.gz"
    else
      appdata_url = "http://download.opensuse.org/distribution/#{dist}/repo/#{flavour}/suse/setup/descr/appdata.xml.gz"
    end
    appdata = ApiConnect::get appdata_url
    zipfilename = File.join( Rails.root.join('tmp'), "appdata-" + dist + ".xml.gz" )
    filename = File.join( Rails.root.join('tmp'), "appdata-" + dist + ".xml" )
    File.open(zipfilename, "w+") do |f|
      f.write(appdata.body)
    end 
    `gunzip -f #{zipfilename}`
    xmlfile = File.open(filename)
    doc = Nokogiri::XML(xmlfile)
    xmlfile.close
    doc
  end


end
