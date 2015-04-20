class GroupUserInfo

  include Constants
  
  def initialize(group_name, state, user)
    @user = user

    @group = Group.find_by("lower(name) = ?", group_name.downcase)
    return if @group.nil?
    return if !@group.active?

    return if !state.nil? && !StatementStates.key?(state.to_sym)
    @state = (state || :accepted.to_s).to_sym

    if @user
      @active_member  = @group.active_members.find_by(user_id: @user.id)
      @member_history = @group.membership_histories.where(user_id: @user.id, active: true).first

      @email_activated     = get_email_activated
      @email_eligible      = get_email_eligible
      @invitation_eligible = get_invitation_eligible
      @location_eligible   = get_location_eligible

      @change_eligible = @email_activated && @email_eligible && @invitation_eligible && @location_eligible

      @invitations_remaining = @group.invitations - SentInvitation.num_sent_today(@user, @group) if
        @change_eligible && @group.invitations_required?
    end

    @valid = true
  end

  def valid?
    !@valid.nil?
  end

  def user
    @user
  end

  def group
    @group
  end

  def state
    @state
  end

  def member_history
    @member_history
  end

  def active_member
    @active_member
  end

  def email_activated?
    not_nilfalse @email_activated
  end

  def email_eligible?
    not_nilfalse @email_eligible
  end

  def invitation_eligible?
    not_nilfalse @invitation_eligible
  end
  
  def location_eligible?
    not_nilfalse @location_eligible
  end
  
  def change_eligible?
    not_nilfalse @change_eligible
  end

  def invitations_remaining
    @invitations_remaining
  end

  def support_eligible?(statement)
    GroupUserInfo.support_eligible?(@user, @active_member, statement)
  end
  
  def GroupUserInfo.support_eligible?(user, active_member, statement)
    # can un/support if:
    #  user already supported
    #      OR
    #  user has been active since before it was created
    user && statement.user_supports?(user) || (active_member && active_member.can_support?(statement))
  end

  def vote_eligible?(statement)
    GroupUserInfo.vote_eligible?(@user, @active_member, statement)
  end
  
  def GroupUserInfo.vote_eligible?(user, active_member, statement)
    # can vote if:
    #  user already voted
    #      OR
    # user has been active since before vote began
    user && statement.user_vote(user) || (active_member && active_member.can_vote?(statement))
  end

  def make_member_active
    if @active_member
      @active_member.extend_active
    else
      @active_member = @group.active_members.create!(user_id: @user.id)
    end

    if @member_history
      @member_history.update_attributes(updated_at: Time.zone.now)
    else
      @member_history = MembershipHistory.create(user_id: @user.id, group_id: @group.id, active: true)
    end

    # automatically follow when user becomes active
    @user.follow(@group)
  end

  def make_member_inactive(send_email = false)
    if @active_member
      @active_member.destroy
      @active_member = nil
    end

    MembershipHistory.create(user_id: @user.id, group_id: @group.id, active: false)

    UserMailer.timed_out(@user, @group).deliver_later if send_email && @user.user_notification.timed_out

    # do NOT automatically unfollow when user becomes inactive
  end

  def distance
    miles = Geocoder::Calculations.distance_between([@group.latitude, @group.longitude],
                                                    [@user.get_location.latitude, @user.get_location.longitude])
    miles * Locations::METERS_PER_MILE
  end

  private

  def not_nilfalse(var)
    !var.nil? && var
  end

  def get_email_activated
    @user.email_addresses.where(activated: true).any?
  end

  def get_email_eligible
    return true if !@group.group_email_domains.any?
    @user.email_addresses.where(activated: true).each do |email_address|
      return true if @group.group_email_domains.exists?(domain: email_address.domain)
    end
    false
  end

  def get_invitation_eligible
    return true if !@group.invitations_required?
    return true if @member_history
    return true if !@user.received_invitations.find_by(group_id: @group.id).nil?
    false
  end

  def get_location_eligible
    @group.radius.nil? || (@user.get_location && distance <= @group.radius)
  end
end
