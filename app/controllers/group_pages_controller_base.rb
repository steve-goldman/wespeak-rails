class GroupPagesControllerBase < ApplicationController

  include GroupsHelper
  
  protected

  def group_found
    @group = Group.where("lower(name) = ?", params[:name].downcase).first
    render('shared/error_page') and return if @group.nil?
    redirect_with_flash(FlashMessages::GROUP_NOT_ACTIVE, request.referer || root_url) if
      !@group.active?
  end

  def membership_info
    if logged_in?
      @active_member = @group.active_members.find_by(user_id: current_user.id)
      @membership_history = @group.membership_histories.where(user_id: current_user.id, active: true).first
      if @group.invitations != Invitations::NOT_REQUIRED
        @num_invitations_remaining = @group.invitations - SentInvitation.num_sent_today(current_user, @group)
      end
    else
      @active_member = nil
      @membership_history = nil
    end
  end

  def email_eligible
    @email_eligible = true and return if !@group.group_email_domains.any?
    if logged_in?
      current_user.email_addresses.each do |email|
        @email_eligible = true and return if
          email.activated && @group.group_email_domains.exists?(domain: email.domain)
      end
    else
      @email_eligible = false
    end
  end

  def change_eligible
    @change_eligible = logged_in? && @email_eligible
    logger.info "CHANGE_ELIGIBLE: #{@change_eligible}"
  end

  def enforce_change_eligible
    redirect_with_flash(FlashMessages::NOT_CHANGE_ELIGIBLE, request.referer) if !@change_eligible
  end

end
