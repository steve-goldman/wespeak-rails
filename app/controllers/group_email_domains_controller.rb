class GroupEmailDomainsController < ApplicationController

  include MyGroupsHelper

  before_action :logged_in,               only: [:create, :destroy]
  before_action :can_create_groups,       only: [:create, :destroy]
  before_action :group_known,             only: [:create, :destroy]
  before_action :email_domain_known,      only: [:destroy]
  before_action :user_matches,            only: [:create, :destroy]
  before_action :group_not_active,        only: [:create, :destroy]
  before_action :email_domain_creates,    only: [:create]
  

  def create
    redirect_to edit_my_group_path(@group.id)
  end

  def destroy
    @domain.destroy
    redirect_to edit_my_group_path(@group.id)
  end

  private

  def logged_in
    @user = current_user
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if @user.nil?
  end

  def can_create_groups
    redirect_with_flash(FlashMessages::CANNOT_CREATE_GROUPS, root_url) if !@user.can_create_groups?
  end

  def group_known
    @group = Group.find_by(id: params[:my_group_id])
    redirect_with_flash(FlashMessages::GROUP_UNKNOWN, my_groups_path) if @group.nil?
  end

  def email_domain_known
    @domain = GroupEmailDomain.find_by(group_id: @group.id, id: params[:id])
    redirect_with_flash(FlashMessages::DOMAIN_UNKNOWN, my_groups_path) if @domain.nil?
  end

  def user_matches
    redirect_with_flash(FlashMessages::USER_MISMATCH, my_groups_path) if @group.user_id != @user.id
  end

  def group_not_active
    redirect_with_flash(FlashMessages::GROUP_ACTIVE, my_groups_path) if @group.active?
  end

  def email_domain_creates
    group_email_domain = @group.group_email_domains.create(domain: params[:group_email_domain][:domain])
    @group.group_email_domains.destroy(group_email_domain) and render_with_validation_flash(group_email_domain, 'my_groups/edit') if !group_email_domain.valid?
  end

end
