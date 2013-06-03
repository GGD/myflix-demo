Myflix::Application.routes.draw do
  match 'home' => 'categories#index', as: 'home'

  get 'ui(/:action)', controller: 'ui'

  resources :categories, only: [:index, :show]
  resources :videos, only: [:show]

  root to: 'categories#index'
end
