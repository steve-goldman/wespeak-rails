class GroupPagesControllerBase < ApplicationController

  protected

  def group_found
    @group = Group.where("lower(name) = ?", params[:name].downcase).first
    render('shared/error_page') if @group.nil?
  end

  def is_active_member
    if logged_in?
      @active_member = @group.active_members.find_by(user_id: current_user.id)
    else
      @active_member = nil
    end
  end

  def email_eligible
    return true if !@group.group_email_domains.any?
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

end
