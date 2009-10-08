begin
  require 'active_support'
rescue LoadError
  require 'rubygems'
  gem 'activesupport'
end

require File.join(File.dirname(__FILE__), 'activexml/config')
require File.join(File.dirname(__FILE__), 'activexml/node')
require File.join(File.dirname(__FILE__), 'activexml/base')
require File.join(File.dirname(__FILE__), 'activexml/transport')

