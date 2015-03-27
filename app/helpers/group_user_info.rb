class GroupUserInfo
  def initialize(group_name, user)
    @user = user

    @group = Group.find_by("lower(name) = ?", group_name.downcase)
    return if @group.nil?
    return if !@group.active?

    if @user
      @active_member  = @group.active_members.find_by(user_id: @user.id)
      @member_history = @group.membership_histories.where(user_id: @user.id, active: true).first

      @email_eligible = get_email_eligible

      # TODO: invitation eligible
      # TODO: facebook eligible
      # TODO: location eligible

      @change_eligible = @email_eligible
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

  def member_history
    @member_history
  end

  def active_member
    @active_member
  end

  def email_eligible?
    !@email_eligible.nil? && @email_eligible
  end
  
  def change_eligible?
    !@change_eligible.nil? && @change_eligible
  end

  def invitations_remaining
    @invitations_remaining
  end

  private

  def get_email_eligible
    return true if !@group.group_email_domains.any?
    @user.email_addresses.where(activated: true).each do |email|
      return true if @group.group_email_domains.exists?(domain: email.domain)
    end
  end
end
