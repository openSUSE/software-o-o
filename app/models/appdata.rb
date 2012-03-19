class Appdata < ActiveXML::Base

  def self.get_distribution
    ApiConnect::get "http://download.opensuse.org/factory/repo/oss/suse/setup/descr/appdata.xml.gz"

  end



end
