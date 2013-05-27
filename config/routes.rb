Myflix::Application.routes.draw do
  match 'home' => 'videos#index', as: 'home'

  get 'ui(/:action)', controller: 'ui'

  root to: 'videos#index'
end
