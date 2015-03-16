Rails.application.routes.draw do
  root   'static_pages#home'

  get    'signup' => 'users#new'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get    'settings' => 'settings/generals#show'
  
  resources :users
  resources :email_address_activations, only: [:edit, :update]
  resources :password_resets,           only: [:new, :create, :edit, :update]

  namespace :settings do
    resource  :general,          only: [:show, :update]
    resources :email_identities, only: [:index, :create, :destroy, :edit]
    resource  :notifications,    only: [:show]
  end
end
