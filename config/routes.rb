Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'categories#index', as: 'home'
  get 'register', to: 'users#new', as: 'register'
  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  get 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  get 'my_queue', to: 'queue_items#index'

  root to: 'static#front'

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :categories, only: [:index, :show]
  resources :videos, only: [:show] do
    get 'search', to: 'videos#search', on: :collection
    resources :reviews, only: [:create]
  end
  resources :queue_items, only: [:create]

end
