Fetchit::Application.routes.draw do
  resources :links, :only => [:index, :create, :show] do
    get 'page/:page', :action => :index, :on => :collection
    get 'raw', :action => :raw
  end
  
  root :to => 'links#index'
  
  mount Resque::Server, :at => '/resque'
end
