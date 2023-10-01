Rails.application.routes.draw do
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
