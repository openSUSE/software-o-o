
desc "Fill cache with app data from Factory"
task(:fill_search_cache => :environment) do
  appdata = Appdata.get "tumbleweed"
  pkg_list =appdata[:apps].map{|p| p[:pkgname]}.uniq
  puts "Caching data for #{pkg_list.size} apps"
  pkg_list.each_with_index do |pkg, number|
    Seeker.prepare_result("\"#{pkg}\"", nil, nil, nil, nil)
    Seeker.prepare_result("#{pkg}", nil, nil, nil, nil)
    puts "Cached data for #{pkg} (#{number}/#{pkg_list.size})"
  end

end
