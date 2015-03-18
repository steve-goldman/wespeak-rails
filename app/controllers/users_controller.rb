class UsersController < ApplicationController

  include UsersHelper

  before_action :not_logged_in, only: [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # try to add the email address
      email_address = @user.email_addresses.create(email: @user.email)
      if email_address.valid?
        # update the user record with the email address id
        @user.update_attribute(:primary_email_address_id, email_address.id)
        # this is success
        UserMailer.email_address_activation(@user, email_address).deliver_now
        redirect_with_flash(FlashMessages::EMAIL_SENT, root_url)
      else
        @user.destroy
        redirect_with_validation_flash(email_address, root_url)
      end
    else
      redirect_with_validation_flash(@user, root_url)
    end
  end

  # private section
  
  private

  def not_logged_in
    redirect_with_flash(FlashMessages::LOGGED_IN, root_url) if logged_in?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
