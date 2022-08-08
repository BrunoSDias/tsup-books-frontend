Rails.application.routes.draw do
  root "books#index"
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get 'sessions/signin'
  get 'sessions/signup'
  post 'sessions/login'
  post 'sessions/create'

  post 'sessions/signout'
end
