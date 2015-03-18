class Settings::GeneralsController < ApplicationController

  include Settings::GeneralsHelper

  before_action :logged_in,                      only: [:show, :update]
  before_action :current_password_authenticated, only: [:update]
  before_action :password_not_blank,             only: [:update]
  before_action :user_updates,                   only: [:update]

  def show
  end

  def update
    redirect_with_flash(FlashMessages::SUCCESS, settings_general_path)
  end

  private

  def change_password_params
    params.require(:change_password).permit(:password, :password_confirmation)
  end

  def logged_in
    @user = current_user
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if @user.nil?
  end

  def current_password_authenticated
    render_with_flash(FlashMessages::PASSWORD_INCORRECT, action: :show) if
      !@user.authenticate(params[:change_password][:current_password])
  end

  def password_not_blank
    render_with_flash(FlashMessages::PASSWORD_BLANK, action: :show) if
      params[:change_password][:password].blank?
  end

  def user_updates
    render_with_validation_flash(@user, action: :show) if !@user.update_attributes(change_password_params)
  end

end
