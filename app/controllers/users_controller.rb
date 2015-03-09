class UsersController < ApplicationController

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
        flash[:info] = "Please check your email to activate your account"
        redirect_to root_url
      else
        @user.destroy
        PageErrors.add_errors email_address.errors.full_messages
        redirect_to root_url
      end
    else
      PageErrors.add_errors @user.errors.full_messages
      redirect_to root_url
    end
  end

  # private section
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
