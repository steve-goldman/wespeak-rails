class SentInvitationsController < GroupPagesControllerBase
  before_action :group_found,             only: [:create]
  before_action :is_active_member,        only: [:create]
  before_action :email_eligible,          only: [:create]
  before_action :change_eligible,         only: [:create]
  before_action :enforce_change_eligible, only: [:create]

  before_action :has_remaining_invites,   only: [:create]
  before_action :invitation_creates,      only: [:create]

  def create
    email_address = EmailAddress.find_by(email: @email)
    if !email_address.nil?
      email_address.user.received_invitations.first_or_create(group_id: @group.id)
      # TODO: send notification of invitation
    else
      # TODO: put this in the invitations pending signup table
      # TODO: send notification of invitation
    end
    
    redirect_with_flash FlashMessages::INVITATION_SENT, request.referer || root_url
  end

  private

  def has_remaining_invites
    redirect_with_flash(FlashMessages::NO_INVITES, request.referer || root_url) if @num_invitations_remaining < 1
  end

  def invitation_creates
    @email = params[:sent_invitations][:email]
    invitation = current_user.sent_invitations.create(group_id: @group.id, email: @email)
    render_with_validation_flash(invitation, action_name) if !invitation.valid?
  end
end
