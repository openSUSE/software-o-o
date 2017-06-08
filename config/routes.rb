SoftwareOO::Application.routes.draw do

  root to: 'distributions#index'
  get '/:locale', to: 'distributions#index'

  resources :distributions, only: [:index] do
    collection do
      get 'tumbleweed'
      get 'tumbleweed/ports', to: 'distributions#tumbleweed_ports'
      get 'tumbleweed/unsupported', to: 'distributions#tumbleweed_unsupported'
      get 'leap'
      get 'leap/ports', to: 'distributions#leap_ports'
      get 'testing'
    end
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

  # compatibility routes for old download implementation
  get 'download' => "download#package"
  get 'download.:format' => "download#package"
  get 'download/iframe' => "download#package", :format => 'iframe'
  get 'download/json' => "download#package", :format => 'json'

  get '/download/:action(.:format)', :controller => 'download'
end
