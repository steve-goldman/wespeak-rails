class GroupPagesControllerBase < ApplicationController

  include GroupsHelper

  before_action :group_user_info
  
  protected

  def group_user_info
    @info = GroupUserInfo.new(params[:name], params[:state], current_user)
    if !@info.valid?
      render('shared/error_page') and return if @info.group.nil?
      redirect_with_flash(FlashMessages::GROUP_NOT_ACTIVE, request.referer || root_url) and return if
        !@info.group.active?
      redirect_with_flash(FlashMessages::STATE_UNKNOWN, request.referer || root_url) and return if
        @info.state.nil?
    end
  end

  def enforce_change_eligible
    redirect_with_flash(FlashMessages::NOT_CHANGE_ELIGIBLE, request.referer) if !@info.change_eligible?
  end

  def get_of_type(type, state)
    @statements = @info.group.get_of_type(type, state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
  end

end
