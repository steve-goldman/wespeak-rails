class ProfilesController < GroupPagesControllerBase
  before_action :group_found,        only: [:show, :activate_member, :deactivate_member]
  before_action :is_active_member,   only: [:show, :activate_member, :deactivate_member]
  before_action :email_eligible,     only: [:show, :activate_member]
  before_action :change_eligible,    only: [:show, :activate_member]

  def show
  end

  def activate_member
    if @change_eligible
      if @active_member
        @active_member.update_attributes(active_seconds: @group.inactivity_timeout_rule, updated_at: Time.zone.now)
      else
        @group.active_members.create(user_id: current_user.id, active_seconds: @group.inactivity_timeout_rule)
      end
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
