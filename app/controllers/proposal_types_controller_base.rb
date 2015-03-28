class ProposalTypesControllerBase < GroupPagesControllerBase

  def initialize(type)
    @type = type
  end

  before_action :enforce_change_eligible, only: [:create]
  before_action :statement_creates,       only: [:create]
  before_action :valid_state,             only: [:index]

  def index
    @statements = @info.group.get_of_type(@type, @state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    make_member_active @info.group, @info.user, @info.active_member
    redirect_to proposal_path(@info.group.name, @statement.id)
  end

  protected

  def statement_creates
    @statement = @info.group.create_statement(@info.user, @type)
    redirect_with_validation_flash(@statement, request.referer || root_url) if !@statement.valid?
  end

  def valid_state
    @state = params[:state].to_sym
    redirect_with_flash(FlashMessages::STATE_UNKNOWN, request.referer || root_url) if !StatementStates.key?(@state)
  end

end
