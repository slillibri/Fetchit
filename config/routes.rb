Fetchit::Application.routes.draw do
  resources :link
  root :to => 'link#index'
  
  mount Resque::Server, :at => '/resque'
end
