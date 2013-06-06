Myflix::Application.routes.draw do
  get 'home' => 'categories#index', as: 'home'

  get 'ui(/:action)', controller: 'ui'

  resources :categories, only: [:index, :show]
  resources :videos, only: [:show] do
    get 'search', to: 'videos#search', on: :collection
  end

  root to: 'categories#index'
end
