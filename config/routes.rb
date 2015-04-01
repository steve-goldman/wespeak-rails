Rails.application.routes.draw do
  root   'static_pages#home'

  # user creation
  get    'users/new',                       to: 'users#new',                        as: :new_user
  post   'users',                           to: 'users#create',                     as: :create_user

  # password reset
  get    'users/password_reset',            to: 'password_resets#new',              as: :new_password_reset
  post   'users/password_reset',            to: 'password_resets#create',           as: :create_password_reset
  get    'users/password_reset/:id/udpate', to: 'password_resets#edit',             as: :edit_password_reset
  patch  'users/password_reset/:id',        to: 'password_resets#update',           as: :update_password_reset

  # email address activation
  get    'users/activate_email/:id',        to: 'email_address_activations#edit',   as: :edit_email_address_activation
  patch  'users/activate_email/:id',        to: 'email_address_activations#update', as: :update_email_address_activation

  # log in/log out
  get    'users/login',                     to: 'sessions#new',                     as: :new_session
  post   'users/login',                     to: 'sessions#create',                  as: :create_session
  delete 'users/logout',                    to: 'sessions#destroy',                 as: :destroy_session

  # user settings
  get    'users/settings',                  to: 'settings/generals#show',           as: :show_settings

  get    'users/settings/general',          to: 'settings/generals#show',           as: :show_settings_general
  patch  'users/settings/general',          to: 'settings/generals#update',         as: :update_settings_general

  get    'users/settings/email',                  to: 'settings/email_identities#index',   as: :settings_email_identities
  post   'users/settings/email',                  to: 'settings/email_identities#create',  as: :create_settings_email_identity
  get    'users/settings/email/:id/make_primary', to: 'settings/email_identities#edit',    as: :edit_settings_email_identity
  delete 'users/settings/email/:id',              to: 'settings/email_identities#destroy', as: :destroy_settings_email_identity

  get    'users/settings/notifications',          to: 'settings/notifications#edit',       as: :edit_settings_notifications
  patch  'users/settings/notifications/update',   to: 'settings/notifications#update',     as: :update_settings_notifications

  # my groups
  get    'users/my_groups',                       to: 'my_groups#index',             as: :my_groups
  get    'users/following',                       to: 'following#index',             as: :following
  get    'users/invitations',                     to: 'invites#index',               as: :invites
  
  # group creation
  get    'groups',                               to: 'groups#index',                as: :groups
  get    'groups/:id/configure',                 to: 'groups#edit',                 as: :edit_group
  post   'groups/:group_id/configure/email',     to: 'group_email_domains#create',  as: :create_group_email_domain
  delete 'groups/:group_id/configure/email/:id', to: 'group_email_domains#destroy', as: :destroy_group_email_domain
  patch  'groups/:id',                           to: 'groups#update',               as: :update_group
  patch  'groups/:id/update_invitations',        to: 'groups#update_invitations',   as: :update_invitations_group
  get    'groups/:id/ready_to_activate',         to: 'groups#ready_to_activate',    as: :ready_to_activate_group
  post   'groups/:id/activate',                  to: 'groups#activate',             as: :activate_group
  delete 'groups/:id',                           to: 'groups#destroy',              as: :destroy_group
  post   'groups',                               to: 'groups#create',               as: :create_group

  # main profile pages
  get    'groups/:name',                       to: 'profiles#show'
  get    'groups/:name/profile',               to: 'profiles#show',   as: :group_profile
  get    'groups/:name/profile/:state',        to: 'profiles#show',   as: :profile

  # support
  post   'groups/:name/support',               to: 'profiles#support',   as: :support
  post   'groups/:name/unsupport',             to: 'profiles#unsupport', as: :unsupport

  # votes
  post   'groups/:name/vote_no',               to: 'profiles#vote_no',   as: :vote_no
  post   'groups/:name/vote_yes',              to: 'profiles#vote_yes',  as: :vote_yes

  # extending and discontinuing active membership
  post   'groups/:name/activate_membership',   to: 'profiles#activate_member',   as: :activate_membership
  delete 'groups/:name/deactivate_membership', to: 'profiles#deactivate_member', as: :deactivate_membership

  # un/follow a group
  post   'groups/:name/follow',                to: 'profiles#follow',    as: :follow
  post   'groups/:name/unfollow',              to: 'profiles#unfollow',  as: :unfollow

  # for sending group invitations
  post   'groups/:name/sent_invitation',       to: 'sent_invitations#create', as: :sent_invitations

  # taglines
  get    'groups/:name/taglines/:state',       to: 'taglines#index',  as: :taglines
  post   'groups/:name/taglines',              to: 'taglines#create', as: :create_tagline
  
  # updates
  get    'groups/:name/updates/:state',        to: 'updates#index',  as: :updates
  post   'groups/:name/updates',               to: 'updates#create', as: :create_update
  
  # rules
  get    'groups/:name/rules/:state',             to: 'rules#index',                          as: :rules
  post   'groups/:name/lifespan_rules',           to: 'rules#create_lifespan_rule',           as: :create_lifespan_rule
  post   'groups/:name/support_needed_rules',     to: 'rules#create_support_needed_rule',     as: :create_support_needed_rule
  post   'groups/:name/votespan_rules',           to: 'rules#create_votespan_rule',           as: :create_votespan_rule
  post   'groups/:name/votes_needed_rules',       to: 'rules#create_votes_needed_rule',       as: :create_votes_needed_rule
  post   'groups/:name/yeses_needed_rules',       to: 'rules#create_yeses_needed_rule',       as: :create_yeses_needed_rule
  post   'groups/:name/inactivity_timeout_rules', to: 'rules#create_inactivity_timeout_rule', as: :create_inactivity_timeout_rule
  
  # invitations
  get    'groups/:name/invitations/:state',       to: 'invitations#index',  as: :invitations
  post   'groups/:name/invitations',              to: 'invitations#create', as: :create_invitation

  # group email domains
  get    'groups/:name/email_addresses/:state',   to: 'group_email_domain_changes#index',                  as: :group_email_domain_changes
  post   'groups/:name/add_email_address',        to: 'group_email_domain_changes#create_add_domain',      as: :add_group_email_domain_change
  post   'groups/:name/rem_email_address',        to: 'group_email_domain_changes#create_rem_domain',      as: :rem_group_email_domain_change
  post   'groups/:name/rem_all_email_address',    to: 'group_email_domain_changes#create_rem_all_domains', as: :rem_all_group_email_domains_change

  # proposals (catch-all)
  get    'groups/:name/proposals/:id',         to: 'proposals#show',  as: :proposal

end
