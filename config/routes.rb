SoftwareOO::Application.routes.draw do

  root to: 'distributions#index'

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

  resources :search, only: [:index] do
  end
  get 'find', to: 'search#find', :format => false

  get 'images.xml', to: 'images#images'

  controller :package do
    get 'package/:package' => :show, :constraints => { :package => /[-+\w\.:\@]+/ }
    get 'package/thumbnail/:package.png' => :thumbnail, :constraints => { :package => /[-+\w\.:\@]+/ }
    get 'package/screenshot/:package.png' => :screenshot, :constraints => { :package => /[-+\w\.:\@]+/ }

    get 'explore' => :explore
    get 'packages' => :explore
    get 'appstore' => :explore
    get 'packages/:category' => :category, :constraints => { :category => /[\w\-\.: ]+/ }
    get 'appstore/:category' => :category, :constraints => { :category => /[\w\-\.: ]+/ }
  end

  namespace 'download' do
    %w(doc appliance package pattern).each do |action|
      get action
    end
  end
  get 'ymp/:project/:repository/:package.ymp', to: 'download#ymp_without_arch_and_version',
      :constraints => { :project => /[\w\-\.:\+]+/, :repository => /[\w\-\.:\+]+/, :package => /[-+\w\.:\@]+/ }
  get 'ymp/:project/:repository/:arch/:binary.ymp', to: 'download#ymp_with_arch_and_version',
      :constrains => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :arch => /[\w\-\.:]+/, :binary => /[\w\-\.:\+]+/ }

  # compatibility routes for old download implementation
  get 'download' => "download#package"
  get 'download.:format' => "download#package"
  get 'download/iframe' => "download#package", :format => 'iframe'
  get 'download/json' => "download#package", :format => 'json'

  # compatibility routes for old site
  get '421', to: redirect('/distributions/leap')
  get '421/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get '422', to: redirect('/distributions/leap')
  get '422/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get '423', to: redirect('/distributions/leap')
  get '423/:locale', to: redirect('/distributions/leap?locale=%{locale}')

  get '121', to: redirect('/distributions/leap')
  get '121/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get '122', to: redirect('/distributions/leap')
  get '122/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get '123', to: redirect('/distributions/leap')
  get '123/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get '131', to: redirect('/distributions/leap')
  get '131/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get '132', to: redirect('/distributions/leap')
  get '132/:locale', to: redirect('/distributions/leap?locale=%{locale}')
  get 'developer', to: redirect('/distributions/testing')
  get 'developer/:locale', to: redirect('/distributions/testing?locale=%{locale}')
  get '/promodvd', to: 'distributions#index'

  # catch all other params as locales...
  get '/:locale', to: 'distributions#index'
end
