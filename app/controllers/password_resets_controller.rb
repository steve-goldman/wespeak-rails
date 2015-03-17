class PasswordResetsController < ApplicationController

  include PasswordResetsHelper

  before_action :email_present,        only: [:create, :edit, :update]
  before_action :email_valid,          only: [:create, :edit, :update]
  before_action :email_active,         only: [:create, :edit, :update]
  before_action :token_present,        only: [:edit, :update]
  before_action :token_not_expired,    only: [:edit, :update]
  before_action :password_present,     only: [:update]
  before_action :password_not_blank,   only: [:update]

  def new
  end

  def edit
  end

  def create
    @email_address.user.create_password_reset_digest
    @email_address.user.send_password_reset_email(@email_address.email)
    redirect_with_flash(FlashMessages::EMAIL_SENT, root_url)
  end

  def update
    if @email_address.user.update_password(params[:password_reset][:password], params[:password_reset][:password_confirmation])
      log_in @email_address.user
      @email_address.user
      redirect_with_flash(FlashMessages::SUCCESS, root_url)
    else
      render_with_validation_flash(@email_address.user, action: :edit)
    end
  end

  private

  def email_present
    render_with_flash(FlashMessages::EMAIL_MISSING, action: :new) if
      params[:password_reset].nil? || params[:password_reset][:email].nil?
  end
  
  def email_valid
    @email_address = EmailAddress.find_by(email: params[:password_reset][:email])
    render_with_flash(FlashMessages::EMAIL_UNKNOWN, action: :new) if @email_address.nil?
  end

  def email_active
    render_with_flash(FlashMessages::EMAIL_NOT_ACTIVE, action: :new) if !@email_address.activated?
  end

  def email_authenticated
    render_with_flash(FlashMessages::EMAIL_NOT_AUTHENTICATED, action: :new) if
      !@email_address.user.password_reset_authenticated?(@password_reset_token)
  end

  def token_present
    @password_reset_token = params[:id]
  end

  def token_not_expired
    render_with_flash(FlashMessages::TOKEN_EXPIRED, action: :new) if
      @email_address.user.password_reset_expired?
  end

  def password_present
    render_with_flash(FlashMessages::PASSWORD_MISSING, action: :edit) if
      params[:password_reset].nil? || params[:password_reset][:password].nil?
  end

  def password_not_blank
    render_with_flash(FlashMessages::PASSWORD_BLANK, action: :edit) if
      params[:password_reset][:password].blank?
  end
end
