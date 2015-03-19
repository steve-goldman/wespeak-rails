class MyGroupsController < ApplicationController

  include MyGroupsHelper

  before_action :logged_in,         only: [:index, :edit, :destroy, :create]
  before_action :can_create_groups, only: [:index, :edit, :destroy, :create]
  before_action :group_creates,     only: [:create]
  before_action :group_known,       only: [:edit, :destroy]
  before_action :user_matches,      only: [:edit, :destroy]
  before_action :group_not_active,  only: [:edit, :destroy]

  def index
  end

  def edit
  end

  def destroy
    @group.destroy
    redirect_to my_groups_path
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
    @group = @user.groups_i_created.create(name: params[:group][:name])
    render_with_validation_flash(@group, action: :index) if !@group.valid?
  end

  def group_known
    @group = Group.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::GROUP_UNKNOWN, my_groups_path) if @group.nil?
  end

  def user_matches
    redirect_with_flash(FlashMessages::USER_MISMATCH, my_groups_path) if @group.user_id != @user.id
  end

  def group_not_active
    redirect_with_flash(FlashMessages::GROUP_ACTIVE, my_groups_path) if @group.active?
  end

end
