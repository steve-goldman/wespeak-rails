class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      # try to add the email address
    else
      render 'static_pages/home'
    end
  end

  # private section
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
