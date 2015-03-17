class UsersController < ApplicationController

  include UsersHelper
  
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
        put_flash(FlashMessages::EMAIL_SENT)
        redirect_to root_url
      else
        @user.destroy
        put_validation_flash(email_address)
        redirect_to root_url
      end
    else
      put_validation_flash(@user)
      redirect_to root_url
    end
  end

  # private section
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
