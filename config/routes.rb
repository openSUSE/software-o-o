ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '/', :controller => 'main', :action => 'index'
  map.connect 'old/:dist', :controller => 'main', :action => 'old_dist', :requirements => { :dist => /[\w\-\.:]+/ }
  map.connect 'developer', :controller => 'main', :action => 'developer'
  map.connect 'developer2', :controller => 'main', :action => 'developer2'
  map.connect 'developer2/download.js', :controller => 'main', :action => 'developer_download_js'
  map.connect 'developer2/:lang', :controller => 'main', :action => 'developer2'

  map.connect 'promodvd', :controller => 'order', :action => 'new'
  map.connect 'promodvd/admin', :controller => 'order', :action => 'admin_index'
  map.connect 'promodvd/admin/:action/:id', :controller => 'order'
  
  map.connect 'ymp/:project/:repository/:package.ymp', 
    :requirements => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :package => /[\w\-\.:]+/ },
    :controller => 'main', :action => 'ymp_without_arch_and_version'
  map.connect 'ymp/:project/:repository/:arch/:binary.ymp',
    :requirements => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :package => /[\w\-\.:]+/ },
    :controller => 'main', :action => 'ymp_with_arch_and_version'

  map.connect '/codecs', :controller => 'codecs', :action => 'index'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
