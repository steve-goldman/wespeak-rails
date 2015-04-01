class SentInvitationsController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action :has_remaining_invites,   only: [:create]
  before_action :invitation_creates,      only: [:create]

  def create
    email_address = EmailAddress.find_by(email: @email)
    if !email_address.nil?
      email_address.user.received_invitations.find_or_create_by(group_id: @info.group.id)
      # TODO: send notification of invitation
    else
      # TODO: put this in the invitations pending signup table
      # TODO: send notification of invitation
    end
    
    redirect_with_flash FlashMessages::INVITATION_SENT, request.referer || root_url
  end

  private

  def has_remaining_invites
    redirect_with_flash(FlashMessages::NO_INVITES, request.referer || root_url) if @info.invitations_remaining < 1
  end

  def invitation_creates
    @email = params[:sent_invitation][:email]
    invitation = @info.user.sent_invitations.create(group_id: @info.group.id, email: @email)
    redirect_with_validation_flash(invitation, request.referer || root_url) if !invitation.valid?
  end
end
