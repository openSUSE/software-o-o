Rails.application.routes.draw  do

  root to: 'package#explore'

  resources :search, only: [:index] do
  end
  get 'find', to: 'search#find', :format => false

  get 'images.xml', to: 'images#images'

  controller :package do
    get 'package/:package', action: :show, constraints: { package: /[-+~\w\.:\@]+/ }
    get 'package/thumbnail/:package.png', action: :thumbnail, constraints: { package: /[-+~\w\.:\@]+/ }
    get 'package/screenshot/:package.png', action: :screenshot, constraints: { package: /[-+~\w\.:\@]+/ }

    get 'explore', action: :explore
    get 'packages', action: :explore
    get 'appstore', action: :explore
    get 'packages/:category', action: :category, constraints: { category: /[\w\-\.: ]+/ }
    get 'appstore/:category', action: :category, constraints: { category: /[\w\-\.: ]+/ }
  end

  namespace 'download' do
    get 'appliance', constraints: ->(request) { request.params[:project].present? }
    get 'package', constraints: ->(request) { request.params[:project].present? && request.params[:package].present? }

    # Show documentation if contraints are not met
    %w(doc appliance package).each do |path|
      get path, action: :doc
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
  get 'distributions', to: redirect('https://get.opensuse.org/')
  get 'distributions/tumbleweed', to: redirect('https://get.opensuse.org/tumbleweed')
  get 'distributions/tumbleweed/ports', to: redirect('https://get.opensuse.org/tumbleweed')
  get 'distributions/tumbleweed/unsupported', to: redirect('https://get.opensuse.org/tumbleweed')
  get 'distributions/leap(/:version)', to: redirect('https://get.opensuse.org/leap')
  get 'distributions/leap/ports', to: redirect('https://get.opensuse.org/leap#ports_images')
  get 'distributions/testing', to: redirect('https://get.opensuse.org/testing')
  get 'distributions/legacy', to: redirect('https://get.opensuse.org/legacy')

  get 'api/v0/distributions', to: redirect('https://get.opensuse.org/api/v0/distributions.json')

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
  get '/promodvd', to: redirect('/distributions')

  # catch all other params as locales...
  get '/:locale', to: 'package#explore'
end
