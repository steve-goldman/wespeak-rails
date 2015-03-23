Rails.application.routes.draw do
  root   'static_pages#home'

  get    'signup' => 'users#new'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get    'settings' => 'settings/generals#show'
  
  resources :users,                     only: [:new, :create]
  resources :email_address_activations, only: [:edit, :update]
  resources :password_resets,           only: [:new, :create, :edit, :update]

  namespace :settings do
    resource  :general,          only: [:show, :update]
    resources :email_identities, only: [:index, :create, :destroy, :edit]
    resource  :notifications,    only: [:show]
  end

  get 'groups/:name',           to: 'groups#show_profile'
  get 'groups/:name/profile',   to: 'groups#show_profile',   as: :profile
  get 'groups/:name/votes',     to: 'groups#show_votes',     as: :votes
  get 'groups/:name/proposals', to: 'groups#show_proposals', as: :proposals
  
  resources :groups,          only: [:index, :edit, :update, :destroy, :create] do
    resources :group_email_domains, only: [:create, :destroy]

    member do
      patch :update_invitations
      get   :ready_to_activate
      post  :activate
    end
  end
end
