Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'auth/register', to: 'auth#register'
  post 'auth/login', to: 'auth#login'
  get 'auth/validate_token', to: 'auth#validate_token'
  get 'auth/refresh_token', to: 'auth#refresh_token'
  get 'secure_data', to: 'secure_data#show'
end
