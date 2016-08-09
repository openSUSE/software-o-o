class Visitor 
  attr_accessor :missing_codecs
  attr_accessor :os_release, :language, :client_version, :kernel, :gstreamer_package, :xine_package, :user_agent, :ip_address, :application

  def initialize(opt)
    self.os_release = opt[:os_release]
    self.language = opt[:language]
    self.client_version = opt[:client_version]
    self.kernel = opt[:kernel]
    self.gstreamer_package = opt[:gstreamer_package]
    self.xine_package = opt[:xine_package]
    self.user_agent = opt[:user_agent]
    self.ip_address = opt[:ip_address]
    self.missing_codecs = Array.new
  end
end
