class InvitationsController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :invitation
  end

  before_action :invitation_creates,      only: [:create]

  before_action do
    get_of_type(:invitation, (params[:state] || :alive.to_s).to_sym)
  end

  private

  def invitation_creates
    invitation = Invitation.create(statement_id: @statement.id, invitations: params[:invitation][:invitations])
    @statement.destroy and redirect_with_validation_flash(invitation, request.referer || root_url) if !invitation.valid?
  end

end
