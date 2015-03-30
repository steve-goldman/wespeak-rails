class InvitationsController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action :statement_creates,       only: [:create]
  before_action :invitation_creates,      only: [:create]

  before_action do
    get_of_type(:invitation, (params[:state] || :alive.to_s).to_sym)
  end

  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to invitations_path(@info.group.name, :alive) }
      format.js   { render 'group_pages/show_tabs' }
    end
  end

  def index
    respond_to do |format|
      format.html
      format.js { render 'group_pages/show_tabs' if params[:page].nil? }
    end
  end

  private

  def statement_creates
    logger.info("***********creating statement")
    @info.make_member_active
    @statement = @info.group.create_statement(@info.user, :invitation)
    redirect_with_validation_flash(@statement, request.referer || root_url) if !@statement.valid?
  end

  def invitation_creates
    logger.info("***********creating invitation with: #{params[:invitation].inspect}")
    invitation = Invitation.create(statement_id: @statement.id, invitations: params[:invitation][:invitations])
    @statement.destroy and redirect_with_validation_flash(invitation, request.referer || root_url) if !invitation.valid?
    logger.info("***********created")
  end

end
