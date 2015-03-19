class GroupsController < ApplicationController

  include GroupsHelper

  before_action :logged_in,         only: [:index, :new, :create]
  before_action :can_create_groups, only: [:index, :new, :create]
  before_action :group_creates,     only: [:create]

  def index
  end
  
  def new
  end

  def create
    redirect_with_flash(FlashMessages::SUCCESS, root_url)
  end

  private

  def logged_in
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if !logged_in?
  end

  def can_create_groups
    @user = current_user
    redirect_with_flash(FlashMessages::CANNOT_CREATE_GROUPS, root_url) if !@user.can_create_groups?
  end

  def group_creates
    group = @user.groups.create(name: params[:group][:name])
    render_with_validation_flash(group, action: :new) if !group.valid?
  end
end
