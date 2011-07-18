Fetchit::Application.routes.draw do
  resources :link do
    get 'page/:page', :action => :index, :on => :collection
  end
  
  root :to => 'link#index'
  
  mount Resque::Server, :at => '/resque'
end
