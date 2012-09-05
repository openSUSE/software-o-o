SoftwareOO::Application.routes.draw do

  controller :main do
    match '/' => :index
    match 'developer' => :developer
    match ':release/download.js' => :download_js
    match '122' => :index
    match '122/:lang' => :release, :release => "122"
    match '121/:lang' => :release, :release => "121"
    match '114/:lang' => :release, :release => "114", :outdated => true

    match 'change_install' => :change_install

    match 'ymp/:project/:repository/:package.ymp' => :ymp_without_arch_and_version,
          :constrains => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :package => /[\w\-\.:\+]+/ }
    match 'ymp/:project/:repository/:arch/:binary.ymp' => :ymp_with_arch_and_version,
          :constrains => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :arch => /[\w\-\.:]+/, :binary => /[\w\-\.:\+]+/ }

    #map unavailable version to the latest release
    match ':version/:lang' => :release, :release => "122", :requirements => { :version => /[\d]+/ }
    match 'developer/:lang' => :release, :release => "developer"
  end

  controller :search do
    match 'search' => :searchresult
    match 'find' => :find
  end
  
  controller :package do 
    match 'package/:package' => :show, :constrains => { :package => /[\w\-\.:\+]+/ }
    match 'package/thumbnail/:package.png' => :thumbnail, :constrains => { :package => /[\w\-\.:\+]+/ }
    match 'package/screenshot/:package.png' => :screenshot, :constrains => { :package => /[\w\-\.:\+]+/ }

    match 'packages' => :categories
    match 'appstore' => :categories
    match 'appstore/:category' => :category, :constrains => { :category => /[\w\-\.: ]+/ }
  end

  match 'promodvd' => "order#new"
  match 'promodvds' => "order#new"

  match 'codecs' => "codecs#index"

  # compatibility routes for old download implementation
  match 'download' => "download#package"
  match 'download.:format' => "download#package"
  match 'download/iframe' => "download#package", :format => 'iframe'
  match 'download/json' => "download#package", :format => 'json'

#  match '/download/:action.:format', :controller => 'download'

end
