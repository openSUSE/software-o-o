class Appdata < ActiveXML::Base

  # Get the appdata xml for a distribution
  # TODO: atm we only offer appdata for Factory
  def self.get_distribution dist
    appdata = ApiConnect::get "http://download.opensuse.org/factory/repo/oss/suse/setup/descr/appdata.xml.gz"
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
