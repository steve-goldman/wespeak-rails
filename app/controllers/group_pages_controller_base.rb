class GroupPagesControllerBase < ApplicationController

  include GroupsHelper
  
  protected

  def group_found
    @group = Group.where("lower(name) = ?", params[:name].downcase).first
    render('shared/error_page') if @group.nil?
    redirect_with_flash(FlashMessages::GROUP_NOT_ACTIVE, request.referer || root_url) if
      !@group.active?
  end

  def is_active_member
    if logged_in?
      @active_member = @group.active_members.find_by(user_id: current_user.id)
    else
      @active_member = nil
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
    @change_eligible = @email_eligible
  end

  def enforce_change_eligible
    redirect_with_flash [FlashMessages::NOT_CHANGE_ELIGIBLE], request.referer if !@change_eligible
  end

end
