class Settings::GeneralsController < ApplicationController
  before_action :get_user,       only: [:show, :update]
  before_action :user_logged_in, only: [:show, :update]

  def show
  end

  def update
    if !@user.authenticate(params[:change_password][:current_password])
      flash[:danger] = "Incorrect password"
    elsif params[:change_password][:password].blank?
      flash[:danger] = "Password can't be blank"
    elsif !@user.update_attributes(change_password_params)
      PageErrors.add_errors @user.errors.full_messages
    else
      flash[:success] = "Password has been changed"
    end

    redirect_to settings_general_path
  end

  private

  def get_user
    @user = current_user
  end

  def user_logged_in
    unless !current_user.nil?
      flash[:danger] = "Please log in to access this page"
      redirect_to root_url
    end
  end

  def change_password_params
    params.require(:change_password).permit(:password, :password_confirmation)
  end
end
