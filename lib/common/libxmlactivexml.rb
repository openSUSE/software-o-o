begin
  require 'active_support'
rescue LoadError
  require 'rubygems'
  gem 'activesupport'
end

require File.join(File.dirname(__FILE__), 'activexml/config')
require File.join(File.dirname(__FILE__), 'activexml/libxmlnode')
require File.join(File.dirname(__FILE__), 'activexml/libxmlbase')
require File.join(File.dirname(__FILE__), 'activexml/transport')

