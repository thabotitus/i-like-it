Rails.application.routes.draw do
  get 'dashboard/index'

  root 'home#index'

  resources :dashboard, only: [:index]
  resources :likeable_content, only: [:show, :new]

  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }
end
