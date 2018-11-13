require "activexml/activexml"
require 'obs'

config = Rails.configuration.x
api = URI(config.api_host)

map = ActiveXML::setup_transport(api.scheme, api.hostname, api.port)

OBS.configure do |obs|
  obs.api_host = config.api_host
  obs.api_username = config.api_username
  obs.api_password = config.api_password
end

map.connect :published, 'rest:///published/:project/:repository/:arch/:name?:view'
map.connect :seeker, 'rest:///search?match=:match',
    :project => 'rest:///search/project/id?match=:match',
    :package => 'rest:///search/package/id?match=:match',
    :pattern => 'rest:///search/published/pattern/id?match=:match',
    :binary => 'rest:///search/published/binary/id?match=:match'
#map.connect :appdata, 'rest:///build/:prj/:repo/:arch/:pkgname/:appdata'
map.connect :attribute, 'rest:///source/:prj/_attribute/:attribute'
map.set_additional_header( "X-Username", config.api_username)
map.login config.api_username, config.api_password
map.set_additional_header( "User-Agent", "software.o.o" )
map.set_additional_header("X-opensuse_data", config.opensuse_cookie) if config.opensuse_cookie
