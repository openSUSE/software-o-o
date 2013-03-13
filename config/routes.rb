SoftwareOO::Application.routes.draw do

  controller :main do
    match '/' => :index
    match 'developer' => :developer
    match ':release/download.js' => :download_js
    match 'main/download' => :download

    match '122' => :release, :release => "122", :outdated => true
    match '122/:locale' => :release, :release => "122", :outdated => true, :constraints => { :locale => /[\w]+/ }
    match '121' => :release, :release => "121", :outdated => true
    match '121/:locale' => :release, :release => "121", :outdated => true, :constraints => { :locale => /[\w]+/ }
    match ':release' => :releasemain, :constraints => { :release => /[123][\d]+/ }, :format => false
    match ':release/:locale' =>  :release, :constraints => { :release => /[123][\d]+/, :locale => /[\w]+/ }, :format => false
    match 'developer/:locale' => :release, :release => "developer", :format => false, :constraints => { :locale => /[\w]+/ }

    match 'change_install' => :change_install

    match 'ymp/:project/:repository/:package.ymp' => :ymp_without_arch_and_version,
          :constraints => { :project => /[\w\-\.:\+]+/, :repository => /[\w\-\.:\+]+/, :package => /[-+\w\.:\@]+/ }
    match 'ymp/:project/:repository/:arch/:binary.ymp' => :ymp_with_arch_and_version,
          :constrains => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :arch => /[\w\-\.:]+/, :binary => /[\w\-\.:\+]+/ }
  end

  controller :search do
    match 'search' => :searchresult, :format => false
    match 'find' => :find, :format => false
  end
  
  controller :package do 
    match 'package/:package' => :show, :constraints => { :package => /[-+\w\.:\@]+/ }
    match 'package/thumbnail/:package.png' => :thumbnail, :constraints => { :package => /[-+\w\.:\@]+/ }
    match 'package/screenshot/:package.png' => :screenshot, :constraints => { :package => /[-+\w\.:\@]+/ }

    match 'packages' => :categories
    match 'appstore' => :categories
    match 'packages/:category' => :category, :constraints => { :category => /[\w\-\.: ]+/ }
    match 'appstore/:category' => :category, :constraints => { :category => /[\w\-\.: ]+/ }
  end

  resource :orders, :controller => "order" do
    member do
     get 'thanks'
    end
  end

  controller 'order' do
    match 'order/thanks' => :thanks
  end

  match 'promodvd' => "order#new"
  match 'promodvds' => "order#new"

  match 'codecs' => "codecs#index"

  match 'statistic' => "statistic#index"

  # compatibility routes for old download implementation
  match 'download' => "download#package"
  match 'download.:format' => "download#package"
  match 'download/iframe' => "download#package", :format => 'iframe'
  match 'download/json' => "download#package", :format => 'json'

  match '/download/:action(.:format)', :controller => 'download'

end
