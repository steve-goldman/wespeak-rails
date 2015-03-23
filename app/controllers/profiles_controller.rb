class ProfilesController < GroupPagesControllerBase
  before_action :group_found,             only: [:show, :activate_member, :deactivate_member]
  before_action :is_active_member,        only: [:show, :activate_member, :deactivate_member]
  before_action :email_eligible,          only: [:show, :activate_member]
  before_action :change_eligible,         only: [:show, :activate_member]
  before_action :enforce_change_eligible, only: [:activate_member]

  def show
  end

  def activate_member
    if @active_member
      @active_member.extend_active @group.inactivity_timeout_rule
    else
      @group.active_members.create(user_id: current_user.id,
                                   active_seconds: @group.inactivity_timeout_rule)
    end
    redirect_to request.referer
  end

  def deactivate_member
    if @active_member
      @active_member.destroy
    end
    redirect_to request.referer
  end

end
