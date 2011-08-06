Fetchit::Application.routes.draw do
  resources :links do
    get 'page/:page', :action => :index, :on => :collection
  end
  
  root :to => 'links#index'
  
  mount Resque::Server, :at => '/resque'
end
