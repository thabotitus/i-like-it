Rails.application.routes.draw do
  get 'dashboard/index'

  root 'home#index'

  resources :dashboard, only: [:index]

  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }
end
