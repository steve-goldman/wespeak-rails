class ProfilesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:activate_member]

  def show
  end

  def activate_member
    make_member_active @info.group, @info.user, @info.active_member
    redirect_to request.referer
  end

  def deactivate_member
    make_member_inactive @info.group, @info.user, @info.active_member
    redirect_to request.referer
  end

end
