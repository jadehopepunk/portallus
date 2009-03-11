ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.

  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  map.connect ':controller/:action/:file', :requirements => {:controller => 'selenium_test_suite'}
  map.connect ':controller/:action/:file/:test', :requirements => {:controller => 'selenium_test_suite'}
  map.connect ':controller/:action/:id', :requirements => {:controller => 'testdata'}

  map.connect '', :controller => 'section', :action => 'show', :username => 'portallus'
  map.connect 'home/section/:action/*name', :controller => 'section', :username => 'portallus', :requirements => {:action => /edit|new|move_up|move_down|delete/}
  map.connect 'home/*name', :controller => 'section', :action => 'show', :username => 'portallus'
  map.connect 'people/:username/section/:action/', :controller => 'section', :requirements => {:action => /new/}
  map.connect 'people/:username/section/:action/*name', :controller => 'section', :requirements => {:action => /edit|new|rename|move_up|move_down|delete/}
  map.connect 'people/:username/*name', :controller => 'section', :action => 'show'

  map.connect ':controller/:action/:id', :requirements => {:controller => 'user'}
  map.connect ':controller/:action/:id', :requirements => {:controller => 'person'}
  map.connect ':controller/:action/:site', :requirements => {:controller => 'image'}

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
