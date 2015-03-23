class SessionsController < ApplicationController
  before_action :not_logged_in,          only: [:new, :create]
  before_action :email_present,          only: [:create]
  before_action :email_active,           only: [:create]
  before_action :password_authenticated, only: [:create]
  before_action :logged_in,              only: [:destroy]
  
  def new
    @referer = request.referer
  end
  
  def create
    log_in @email_address.user
    params[:session][:remember_me] == '1' ?
      remember(@email_address.user) : forget(@email_address.user)
    redirect_to params[:referer] || root_url
  end
  
  def destroy
    log_out
    redirect_to request.referer || root_url
  end
  
  private
  
  def not_logged_in
    redirect_with_flash(FlashMessages::LOGGED_IN, root_url) if logged_in?
  end

  def email_present
    @email_address = EmailAddress.find_by(email: params[:session][:email].downcase)
    render_with_flash(FlashMessages::INVALID_EMAIL_OR_PASSWORD, action: :new) if @email_address.nil?
  end

  def email_active
    render_with_flash(FlashMessages::EMAIL_NOT_ACTIVATED, action: :new) if !@email_address.activated?
  end

  def password_authenticated
    render_with_flash(FlashMessages::INVALID_EMAIL_OR_PASSWORD, action: :new) if
      !@email_address.user.authenticate(params[:session][:password])
  end
  
  def logged_in
    redirect_to root_url if !logged_in?
  end
end
