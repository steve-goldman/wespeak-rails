class EmailAddressActivationsController < ApplicationController

  include EmailAddressActivationsHelper

  before_action :email_present,          only: [:edit, :update]
  before_action :email_valid,            only: [:edit, :update]
  before_action :email_inactive,         only: [:edit, :update]
  before_action :password_present,       only: [:update]
  before_action :password_authenticated, only: [:update]
  before_action :token_present,          only: [:edit, :update]
  before_action :token_authenticated,    only: [:update]
  
  def edit
  end

  def update
    @email_address.update_attributes({ activated: true, activated_at: Time.zone.now })
    log_in @email_address.user
    redirect_with_flash(FlashMessages::SUCCESS, settings_email_identities_path)
  end

  private

  def email_present
    redirect_with_flash(FlashMessages::EMAIL_MISSING, root_url) if params[:email].nil?
  end

  def email_valid
    @email_address = EmailAddress.find_by(email: params[:email])
    redirect_with_flash(FlashMessages::EMAIL_UNKNOWN, root_url) if @email_address.nil?
  end

  def email_inactive
    redirect_with_flash(FlashMessages::EMAIL_ALREADY_ACTIVE, root_url) if @email_address.activated?
  end

  def password_present
    render_with_flash(FlashMessages::PASSWORD_MISSING, action: :edit) if
      params[:activation].nil? || params[:activation][:password].nil?
  end

  def password_authenticated
    render_with_flash(FlashMessages::PASSWORD_INCORRECT, action: :edit) if
      !@email_address.user.authenticate(params[:activation][:password])
  end

  def token_present
    @activation_token = params[:id]
  end
  
  def token_authenticated
    redirect_with_flash(FlashMessages::TOKEN_INVALID, root_url) if
      !@email_address.authenticated?(@activation_token)
  end
  
end
