class Settings::NotificationsController < ApplicationController

  include Settings::NotificationsHelper
  
  before_action :logged_in
  before_action :fields_update, only: [:update]

  def edit
  end

  def update
    redirect_with_flash(FlashMessages::SUCCESS, edit_settings_notifications_path)
  end

  private

  def logged_in
    @user = current_user
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, new_session_path) if @user.nil?
  end

  def fields_update
    @user.user_notification.update_attributes(user_params)
  end

  def user_params
    params.require(:user_notification).permit(:vote_begins_active,
                                              :vote_ends_active,
                                              :vote_begins_following,
                                              :vote_ends_following,
                                              :support_receipt,
                                              :vote_receipt,
                                              :my_statement_dies)
  end
  
end
