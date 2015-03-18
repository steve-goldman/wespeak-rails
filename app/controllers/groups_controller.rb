class GroupsController < ApplicationController

  include GroupsHelper

  before_action :logged_in,         only: [:new, :create]
  before_action :can_create_groups, only: [:new, :create]

  def new
  end

  def create
  end

  private

  def logged_in
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if !logged_in?
  end

  def can_create_groups
    @user = current_user
    redirect_with_flash(FlashMessages::CANNOT_CREATE_GROUPS, root_url) if !@user.can_create_groups?
  end
end
