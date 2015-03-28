class GroupUserInfo
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

      @email_eligible = get_email_eligible
      @invitation_eligible = get_invitation_eligible

      # TODO: facebook eligible
      # TODO: location eligible

      @change_eligible = @email_eligible && @invitation_eligible
      # TODO: && @invitation_eligible && @facebook_eligible && @location_eligible

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

  def set_state_alive
    @state = :alive
  end

  def member_history
    @member_history
  end

  def active_member
    @active_member
  end

  def email_eligible?
    not_nilfalse @email_eligible
  end

  def invitation_eligible?
    not_nilfalse @invitation_eligible
  end
  
  def change_eligible?
    not_nilfalse @change_eligible
  end

  def invitations_remaining
    @invitations_remaining
  end

  def support_eligible?(statement)
    # can un/support if:
    #  user already supported
    #      OR
    #  user was active when it was created
    statement.user_supports?(@user) || (@active_member && @active_member.can_support?(statement))
  end

  private

  def not_nilfalse(var)
    !var.nil? && var
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
end
