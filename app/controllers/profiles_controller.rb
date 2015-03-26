class ProfilesController < GroupPagesControllerBase
  before_action :group_found,             only: [:show, :activate_member, :deactivate_member]
  before_action :membership_info,         only: [:show, :activate_member, :deactivate_member]
  before_action :email_eligible,          only: [:show, :activate_member]
  before_action :change_eligible,         only: [:show, :activate_member]
  before_action :enforce_change_eligible, only: [:activate_member]

  def show
  end

  def activate_member
    make_member_active @group, current_user, @active_member
    redirect_to request.referer
  end

  def deactivate_member
    make_member_inactive @group, current_user, @active_member
    redirect_to request.referer
  end

end
