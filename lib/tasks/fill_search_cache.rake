# frozen_string_literal: true

desc "Fill cache with app data from Factory"
task(fill_search_cache: :environment) do
  appdata = Appdata.get "factory"
  puts appdata
  pkg_list = appdata[:apps].map { |p| p[:pkgname] }.uniq
  puts "Caching data for #{pkg_list.size} apps"
  pkg_list.each_with_index do |pkg, number|
    OBS.search_published_binary("\"#{pkg}\"")
    OBS.search_published_binary(pkg.to_s)
    puts "Cached data for #{pkg} (#{number}/#{pkg_list.size})"
  end
end
