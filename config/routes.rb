SoftwareOO::Application.routes.draw do

  controller :main do
    get '/' => :index
    get 'developer' => :developer
    get ':release/download.js' => :download_js
    get 'main/download' => :download

    get '123' => :release, :release => "123", :outdated => true
    get '123/:locale' => :release, :release => "123", :outdated => true, :constraints => { :locale => /[\w]+/ }
    get '122' => :release, :release => "122", :outdated => true
    get '122/:locale' => :release, :release => "122", :outdated => true, :constraints => { :locale => /[\w]+/ }
    get '121' => :release, :release => "121", :outdated => true
    get '121/:locale' => :release, :release => "121", :outdated => true, :constraints => { :locale => /[\w]+/ }
    get ':release' => :releasemain, :constraints => { :release => /[123][\d]+/ }, :format => false
    get ':release/:locale' =>  :release, :constraints => { :release => /[123][\d]+/, :locale => /[\w]+/ }, :format => false
    get 'developer/:locale' => :release, :release => "developer", :format => false, :constraints => { :locale => /[\w]+/ }

    get 'change_install' => :change_install

    get 'ymp/:project/:repository/:package.ymp' => :ymp_without_arch_and_version,
          :constraints => { :project => /[\w\-\.:\+]+/, :repository => /[\w\-\.:\+]+/, :package => /[-+\w\.:\@]+/ }
    get 'ymp/:project/:repository/:arch/:binary.ymp' => :ymp_with_arch_and_version,
          :constrains => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :arch => /[\w\-\.:]+/, :binary => /[\w\-\.:\+]+/ }
  end

  controller :search do
    get 'search' => :searchresult, :format => false
    get 'find' => :find, :format => false
  end
  
  controller :package do 
    get 'package/:package' => :show, :constraints => { :package => /[-+\w\.:\@]+/ }
    get 'package/thumbnail/:package.png' => :thumbnail, :constraints => { :package => /[-+\w\.:\@]+/ }
    get 'package/screenshot/:package.png' => :screenshot, :constraints => { :package => /[-+\w\.:\@]+/ }

    get 'packages' => :categories
    get 'appstore' => :categories
    get 'packages/:category' => :category, :constraints => { :category => /[\w\-\.: ]+/ }
    get 'appstore/:category' => :category, :constraints => { :category => /[\w\-\.: ]+/ }
  end

  resource :orders, :controller => "order" do
    member do
     get 'thanks'
    end
  end

  controller 'order' do
    get 'order/thanks' => :thanks
  end

  get 'promodvd' => "order#new"
  get 'promodvds' => "order#new"

  get 'codecs' => "codecs#index"

  get 'statistic' => "statistic#index"

  # compatibility routes for old download implementation
  get 'download' => "download#package"
  get 'download.:format' => "download#package"
  get 'download/iframe' => "download#package", :format => 'iframe'
  get 'download/json' => "download#package", :format => 'json'

  get '/download/:action(.:format)', :controller => 'download'

end
