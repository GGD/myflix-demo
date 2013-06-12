Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home' => 'categories#index', as: 'home'
  get 'register' => 'users#new', as: 'register'
  get 'sign_in' => 'sessions#new', as: 'sign_in'
  get 'sign_out' => 'sessions#destroy', as: 'sign_out'

  root to: 'static#front'

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :categories, only: [:index, :show]
  resources :videos, only: [:show] do
    get 'search', to: 'videos#search', on: :collection
    resources :reviews, only: [:create]
  end

end
