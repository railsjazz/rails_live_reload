Rails.application.routes.draw do
  resources :users
  get '/about', to: 'home#about'
  root "home#index"
end
