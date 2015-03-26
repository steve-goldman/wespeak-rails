class GroupPagesControllerBase < ApplicationController

  include GroupsHelper

  before_action :group_user_info
  
  protected

  def group_user_info
    @info = GroupUserInfo.new(params[:name], current_user)
    if !@info.valid?
      render('shared/error_page') and return if @info.group.nil?
      redirect_with_flash(FlashMessages::GROUP_NOT_ACTIVE, request.referer || root_url) if
        !@info.group.active?
    end
  end

  def enforce_change_eligible
    redirect_with_flash(FlashMessages::NOT_CHANGE_ELIGIBLE, request.referer) if !@info.change_eligible?
  end

end
