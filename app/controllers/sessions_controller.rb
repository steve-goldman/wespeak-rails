class SessionsController < ApplicationController
  before_action :not_logged_in,          only: [:new, :create]
  before_action :email_or_user_present,  only: [:create]
  before_action :password_authenticated, only: [:create]
  before_action :logged_in,              only: [:destroy]
  
  def new
    @referer = request.referer
  end
  
  def create
    log_in @user
    params[:session][:remember_me] == '1' ?
      remember(@user) : forget(@user)
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

  def email_or_user_present
    email_address = EmailAddress.find_by(email: params[:session][:login].downcase)
    if email_address
      @user = email_address.user
    else
      @user = User.where("lower(name) = :name", name: params[:session][:login].downcase).first
    end
    render_with_flash(FlashMessages::INVALID_LOGIN_OR_PASSWORD, action: :new) if !@user
  end

  def password_authenticated
    render_with_flash(FlashMessages::INVALID_LOGIN_OR_PASSWORD, action: :new) if
      !@user.authenticate(params[:session][:password])
  end
  
  def logged_in
    redirect_to root_url if !logged_in?
  end
end
