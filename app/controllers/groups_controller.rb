class GroupsController < ApplicationController

  include GroupsHelper

  before_action :logged_in,          only: [:index, :edit, :update, :update_invitations, :update_locations, :update_display_name, :update_tagline, :update_profile_image, :destroy, :create, :ready_to_activate, :activate]
  before_action :can_create_groups,  only: [:index, :edit, :update, :update_invitations, :update_locations, :update_display_name, :update_tagline, :update_profile_image, :destroy, :create, :ready_to_activate, :activate]
  before_action :group_creates,      only: [:create]
  before_action :group_known,        only: [:edit, :update, :update_invitations, :update_locations, :update_display_name, :update_tagline, :update_profile_image, :destroy, :ready_to_activate, :activate]
  before_action :user_matches,       only: [:edit, :update, :update_invitations, :update_locations, :update_display_name, :update_tagline, :update_profile_image, :destroy, :ready_to_activate, :activate]
  before_action :group_not_active,   only: [:edit, :update, :update_invitations, :update_locations, :update_display_name, :update_tagline, :update_profile_image, :destroy, :ready_to_activate, :activate]
  before_action :initial_statement_creates, only: [:activate]
  before_action :rules_update,       only: [:update]
  before_action :invitations_update, only: [:update_invitations]
  before_action :locations_update,   only: [:update_locations]
  before_action :display_name_updates, only: [:update_display_name]
  before_action :tagline_updates,    only: [:update_tagline]
  before_action :profile_image_updates, only: [:update_profile_image]

  def index
    @groups_pending = Group.where(user_id: @user.id, active: false)
    # TODO: also include following groups here
    group_ids = "SELECT group_id FROM active_members WHERE user_id = :user_id"
    @my_groups = Group.where("id IN (#{group_ids})", user_id: @user.id)
  end

  def edit
  end

  def ready_to_activate
  end

  def activate
    @group.activate
    redirect_with_flash(FlashMessages::ACTIVATED_SUCCESS, profile_path(@group.name, :accepted))
  end

  def update
    redirect_with_flash(FlashMessages::UPDATE_SUCCESS, edit_group_path(id: @group.id))
  end

  def update_invitations
    redirect_with_flash(FlashMessages::UPDATE_INVITATIONS_SUCCESS, edit_group_path(id: @group.id))
  end

  def update_locations
    redirect_with_flash(FlashMessages::UPDATE_LOCATIONS_SUCCESS, edit_group_path(id: @group.id))
  end

  def update_display_name
    redirect_with_flash(FlashMessages::UPDATE_DISPLAY_NAME_SUCCESS, edit_group_path(id: @group.id))
  end

  def update_tagline
    redirect_with_flash(FlashMessages::UPDATE_TAGLINE_SUCCESS, edit_group_path(id: @group.id))
  end

  def update_profile_image
    # delete the old image here?
    redirect_with_flash(FlashMessages::UPDATE_PROFILE_IMAGE_SUCCESS, edit_group_path(id: @group.id))
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end
  
  def create
    redirect_to edit_group_path(@group.id)
  end

  private

  def logged_in
    @user = current_user
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if !logged_in?
  end

  def can_create_groups
    redirect_with_flash(FlashMessages::CANNOT_CREATE_GROUPS, root_url) if !@user.can_create_groups?
  end

  def group_creates
    @group = @user.groups_i_created.create(name: params[:group][:name])
    redirect_with_validation_flash(@group, action: :index) if !@group.valid?
  end

  def group_known
    @group = Group.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::GROUP_UNKNOWN, groups_path) if @group.nil?
  end

  def user_matches
    redirect_with_flash(FlashMessages::USER_MISMATCH, groups_path) if @group.user_id != @user.id
  end

  def group_not_active
    redirect_with_flash(FlashMessages::GROUP_ACTIVE, groups_path) if @group.active?
  end

  def rules_update
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(lifespan_rule:           params[:group][:lifespan_rule],
                                support_needed_rule:     params[:group][:support_needed_rule],
                                votespan_rule:           params[:group][:votespan_rule],
                                votes_needed_rule:       params[:group][:votes_needed_rule],
                                yeses_needed_rule:       params[:group][:yeses_needed_rule],
                                inactivity_timeout_rule: params[:group][:inactivity_timeout_rule])
  end

  def invitations_update
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(invitations: params[:invitations][:per_day])
  end

  def locations_update
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(latitude:  params[:group][:latitude],
                                longitude: params[:group][:longitude],
                                radius:    params[:group][:radius])
  end

  def display_name_updates
    display_name = params[:display_name][:display_name]
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(display_name: display_name.blank? ? nil : display_name)
  end

  def tagline_updates
    tagline = params[:tagline][:tagline]
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(tagline: tagline.blank? ? nil : tagline)
  end

  def profile_image_updates
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(profile_image: params[:image])
  end

  def initial_statement_creates
    statement = Statement.new_statement(Time.zone.now, @group, @group.user, :initial_statement)
    statement.update_attributes(state:         StatementStates[:accepted],
                                vote_ended_at: Time.zone.now)
    redirect_with_validation_flash(statement, request.referer || root_url) if !statement.valid?
    
    initial_stuff = @group.create_initial_group_config(statement)
    redirect_with_validation_flash(initial_stuff[:initial_group], request.referer || root_url) and return if !initial_stuff[:initial_group].valid?
    initial_stuff[:initial_group_email_domains].each do |group_email_domain|
      redirect_with_validation_flash(group_email_domain, request.referer || root_url) and return if !group_email_domain.valid?
    end
  end

end
