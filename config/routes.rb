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

  # main profile pages
  get    'groups/:name',                       to: 'profiles#show'
  get    'groups/:name/profile',               to: 'profiles#show',   as: :profile
  get    'groups/:name/votes',                 to: 'votes#index',     as: :votes
  get    'groups/:name/proposals',             to: 'proposals#index', as: :proposals

  # extending and discontinuing active membership
  post   'groups/:name/activate_membership',   to: 'profiles#activate_member',   as: :activate_membership
  delete 'groups/:name/deactivate_membership', to: 'profiles#deactivate_member', as: :deactivate_membership

  # taglines
  get    'groups/:name/proposals/taglines/new', to: 'taglines#new',    as: :new_tagline
  get    'groups/:name/proposals/taglines',     to: 'taglines#index',  as: :taglines
  post   'groups/:name/proposals/taglines',     to: 'taglines#create'
  
  # proposals (catch-all)
  get    'groups/:name/proposals/:id',          to: 'proposals#show',  as: :proposal

  resources :groups,          only: [:index, :edit, :update, :destroy, :create] do
    resources :group_email_domains, only: [:create, :destroy]

    member do
      patch :update_invitations
      get   :ready_to_activate
      post  :activate
    end
  end
end
