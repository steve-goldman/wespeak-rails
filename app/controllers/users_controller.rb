class UsersController < ApplicationController

  include UsersHelper

  before_action :not_logged_in, only: [:new, :create]
  before_action :captcha_valid, only: [:create]
  before_action :user_valid,    only: [:create]
  before_action :valid_user,    only: [:show]
  
  def new
    @user = User.new
  end
  
  def create
    log_in @user
    redirect_with_flash(FlashMessages::USER_CREATED, root_url)
  end

  def show
    membership_ids = "SELECT MAX(id) FROM membership_histories WHERE user_id = :user_id AND active = 't' GROUP BY user_id, group_id"
    @groups = Group.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
              .joins(:membership_histories).where("membership_histories.id IN (#{membership_ids})", user_id: @user.id)
              .order("membership_histories.updated_at DESC")
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

  def captcha_valid
    if !Rails.env.test? && !verify_recaptcha
      flash.delete(:recaptcha_error)
      redirect_with_flash(FlashMessages::NO_CAPTCHA, request.referer || root_url)
    end
  end

  def user_valid
    @user = User.new(name:                  params[:user][:name],
                     password:              params[:user][:password],
                     password_confirmation: params[:user][:password],
                     can_create_groups:     true)
    redirect_with_validation_flash(@user, root_url) if !@user.save
  end

  def valid_user
    @user = User.find_by(name: params[:name])
    redirect_with_flash(FlashMessages::NAME_UNKNOWN, request.referer || root_url) if !@user
  end
end
