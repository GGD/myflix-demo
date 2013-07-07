Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'password_resets#expired_token'

  root to: 'static#front'

  resources :users, only: [:create, :show]
  resources :relationships, only: [:create, :destroy]
  resources :sessions, only: [:create]
  resources :categories, only: [:index, :show]
  resources :videos, only: [:show] do
    get 'search', to: 'videos#search', on: :collection
    resources :reviews, only: [:create]
  end
  resources :queue_items, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
end
