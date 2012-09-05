require "activexml/activexml"

ActiveXML::Base.config do |conf|
  conf.setup_transport do |map|
    map.default_server :rest, CONFIG['api_host']
    map.connect :published, 'rest:///published/:project/:repository/:arch/:name?:view'
    map.connect :seeker, 'rest:///search?match=:match',
      :project => 'rest:///search/project/id?match=:match',
      :package => 'rest:///search/package/id?match=:match',
      :pattern => 'rest:///search/published/pattern/id?match=:match',
      :binary => 'rest:///search/published/binary/id?match=:match'
    map.connect :appdata, 'rest:///build/:prj/:repo/:arch/:pkgname/:appdata'
    map.connect :attribute, 'rest:///source/:prj/_attribute/:attribute'
  end
  conf.transport_for( :published ).set_additional_header( "X-Username", CONFIG['api_username'])
  unless CONFIG['api_password'].blank?
    conf.transport_for( :published ).login CONFIG['api_username'], CONFIG['api_password']
  end
  conf.transport_for( :published ).set_additional_header( "User-Agent", "software.o.o" )
end
