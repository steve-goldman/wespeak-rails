class UpdatesController < GroupPagesControllerBase
  before_action :group_found,             only: [:create, :index]
  before_action :is_active_member,        only: [:create, :index]
  before_action :email_eligible,          only: [:create, :index]
  before_action :change_eligible,         only: [:create, :index]
  before_action :enforce_change_eligible, only: [:create]

  before_action :statement_creates,       only: [:create]
  before_action :update_creates,          only: [:create]

  def create
    make_member_active @group, current_user, @active_member
    redirect_to proposal_path(@group.name, @statement.id)
  end

  def index
    @statements = @group.get_of_type(:update, :alive, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def statement_creates
    @statement = @group.create_statement(current_user, StatementTypes[:update])
    redirect_with_validation_flash(@statement, request.referer) if !@statement.valid?
  end

  def update_creates
    update = Update.create(statement_id: @statement.id, update_text: params[:update][:update])
    @statement.destroy and render_with_validation_flash(update, action: :index) if !update.valid?
  end

end
