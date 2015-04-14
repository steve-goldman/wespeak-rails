class UsersController < ApplicationController

  include UsersHelper

  before_action :not_logged_in, only: [:new, :create]
  before_action :user_valid,    only: [:create]
  before_action :email_valid,   only: [:create]
  before_action :valid_user,    only: [:show]
  
  def new
    @user = User.new
  end
  
  def create
    @user.update_attribute(:primary_email_address_id, @email_address.id)
    UserMailer.email_address_activation(@user, @email_address).deliver_now
    redirect_with_flash(FlashMessages::EMAIL_SENT, root_url)
  end

  def show
    @groups = Group.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
              .joins(:membership_histories).where(membership_histories: { user_id: @user.id })
              .distinct
    respond_to do |format|
      format.html
      format.js
    end
  end

  # private section
  
  private

  def not_logged_in
    redirect_with_flash(FlashMessages::LOGGED_IN, root_url) if logged_in?
  end

  def user_valid
    @user = User.new(user_params)
    redirect_with_validation_flash(@user, root_url) if !@user.save
  end

  def email_valid
    @email_address = @user.email_addresses.create(email: @user.email)
    @user.destroy and redirect_with_validation_flash(@email_address, root_url) if !@email_address.save
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def valid_user
    @user = User.find_by(name: params[:name])
    redirect_with_flash(FlashMessages::NAME_UNKNOWN, request.referer || root_url) if !@user
  end
end
