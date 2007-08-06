begin
  require 'active_support'
rescue LoadError
  require 'rubygems'
  require_gem 'activesupport'
end

require 'activexml/config'
require 'activexml/smartnode'
require 'activexml/smartbase'
require 'activexml/transport'

ActiveXML::Base.class_eval do
  include ActiveXML::Config
end
