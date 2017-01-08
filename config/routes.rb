Rails.application.routes.draw do
  get 'dashboard/index'

  root 'home#index'

  resources :dashboard, only: [:index]
  resources :likeable_content

  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }

  namespace :api do
    get 'total_likes/:identifier/:api_token', to: 'api#total_likes'
    post 'likes/:identifier/:api_token', to: 'api#create_like'
  end
end
