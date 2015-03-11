class Settings::GeneralsController < ApplicationController
  before_action :get_user,       only: [:show]
  before_action :user_logged_in, only: [:show]

  def show
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
end
