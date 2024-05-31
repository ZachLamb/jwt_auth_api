Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  Rails.application.routes.draw do
    post 'api/register', to: 'auth#register'
    post 'api/login', to: 'auth#login'
    get 'api/validate', to: 'auth#validate_token'
    get 'api/refresh', to: 'auth#refresh_token'
    get 'secure_data', to: 'secure_data#show'
    get 'api/widgets', to: 'widgets#index'
  end

end
