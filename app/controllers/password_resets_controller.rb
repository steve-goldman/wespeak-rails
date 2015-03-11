class PasswordResetsController < ApplicationController
  before_action :get_email,        only: [:edit, :update]
  before_action :valid_email,      only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    email = params[:password_reset][:email].downcase
    
    email_address = EmailAddress.find_by(email: email)

    if !email_address
      flash.now[:danger] = "Email address not found"
      render 'new' and return
    end

    email_address.user.create_password_reset_digest
    email_address.user.send_password_reset_email(email)

    flash[:info] = "Email sent with password reset link"
    redirect_to root_url
  end

  def edit
    @password_reset_token = params[:id]
    @email = params[:email]
  end

  def update
    # we know the email address exists and is activated and the token matches
    # the user's digest

    # disallow a blank password
    if params[:password_reset][:password].blank?
      flash[:danger] = "Password can't be blank"
      redirect_to action: "edit", password_reset_token: params[:password_reset_token], email: params[:email] and return
    end

    if @email_address.user.update_attributes(user_params)
      log_in @email_address.user
      flash[:success] = "Password has been reset"
      redirect_to root_url and return
    end

    PageErrors.add_errors @email_address.user.errors.full_messages
    redirect_to action: "edit", password_reset_token: params[:password_reset_token], email: params[:email] and return
  end

  private

  def user_params
    params.require(:password_reset).permit(:password, :password_confirmation)
  end
  
  def get_email
    @email_address = EmailAddress.find_by(email: params[:email])
  end

  def valid_email
    if !@email_address
      logger.info("valid_email: no such address=#{params[:email]}")
    end

    if !@email_address.activated?
      logger.info("valid_email: not activated address=#{params[:email]}")
    end

    if !@email_address.user.password_reset_authenticated?(params[:id])
      logger.info("valid_email: bad token address=#{params[:email]}")
    end
      
    unless (@email_address &&
            @email_address.activated? &&
            @email_address.user.password_reset_authenticated?(params[:id]))
      flash[:danger] = "Invalid password reset link"
      redirect_to root_url
    end
  end

  def check_expiration
    if @email_address.user.password_reset_expired?
      flash[:danger] = "This link has expired"
      redirect_to new_password_reset_url
    end
  end
end
