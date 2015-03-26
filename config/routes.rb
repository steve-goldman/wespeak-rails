Rails.application.routes.draw do
  root   'static_pages#home'

  # user creation
  get    'users/new',                       to: 'users#new',                        as: :new_user
  post   'users',                           to: 'users#create',                     as: :users

  # password reset
  get    'users/password_reset',            to: 'password_resets#new',              as: :new_password_reset
  post   'users/password_reset',            to: 'password_resets#create',           as: :password_resets
  get    'users/password_reset/:id/udpate', to: 'password_resets#edit',             as: :edit_password_reset
  patch  'users/password_reset/:id',        to: 'password_resets#update',           as: :update_password_reset

  # email address activation
  get    'users/activate_email/:id',        to: 'email_address_activations#edit',   as: :edit_email_address_activation
  patch  'users/activate_email/:id',        to: 'email_address_activations#update', as: :update_email_address_activation

  # log in/log out
  get    'users/login',                     to: 'sessions#new',                     as: :login
  post   'users/login',                     to: 'sessions#create',                  as: :logins
  delete 'users/logout',                    to: 'sessions#destroy',                 as: :logout

  get    'settings' => 'settings/generals#show'
  
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

  # for sending group invitations
  post   'groups/:name/sent_invitation',       to: 'sent_invitations#create', as: :sent_invitations

  # taglines
  get    'groups/:name/proposals/taglines',     to: 'taglines#index',  as: :taglines
  post   'groups/:name/proposals/taglines',     to: 'taglines#create'
  
  # updates
  get    'groups/:name/proposals/updates',     to: 'updates#index',  as: :updates
  post   'groups/:name/proposals/updates',     to: 'updates#create'
  
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
