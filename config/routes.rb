Myflix::Application.routes.draw do
  match 'home' => 'categories#index', as: 'home'

  get 'ui(/:action)', controller: 'ui'

  resources :categories
  resources :videos

  root to: 'categories#index'
end
