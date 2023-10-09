Rails.application.routes.draw do
  # root to: 'admin/top#index'
  root to: 'top#index'

  # get "login" => "sessions#new", as: :login
  # post "session" => "sessions#create", as: :session
  # delete "session" => "sessions#destroy"

  # get 'login', to: 'sessions#new', as: :login
  # post 'session', to: 'sessions#create', as: :session
  # delete 'session', to: 'sessions#destroy'

  scope controller: :sessions do
    get 'login', action: :new, as: :login
    post 'session', action: :create, as: :session
    delete 'session', action: :destroy
  end

  # root "top#index"
  # get 'top/index', to: 'top#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  namespace :admin do
    root "top#index"
  end

  namespace :user do
    root "top#index"
  end
end
