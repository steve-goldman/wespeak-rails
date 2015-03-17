class Settings::GeneralsController < ApplicationController

  include GeneralsHelper

  before_action :get_user,       only: [:show, :update]
  before_action :user_logged_in, only: [:show, :update]

  def show
  end

  def update
    if !@user.authenticate(params[:change_password][:current_password])
      put_flash(FlashMessages::INCORRECT_PASSWORD)
    elsif params[:change_password][:password].blank?
      put_flash(FlashMessages::BLANK_PASSWORD)
    elsif !@user.update_attributes(change_password_params)
      PageErrors.add_errors @user.errors.full_messages
    else
      put_flash(FlashMessages::SUCCESS)
    end

    redirect_to settings_general_path
  end

  private

  def get_user
    @user = current_user
  end

  def user_logged_in
    unless !current_user.nil?
      put_flash(FlashMessages::NOT_LOGGED_IN)
      redirect_to root_url
    end
  end

  def change_password_params
    params.require(:change_password).permit(:password, :password_confirmation)
  end
end
