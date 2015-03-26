class UpdatesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action :statement_creates,       only: [:create]
  before_action :update_creates,          only: [:create]

  def create
    make_member_active @info.group, current_user, @info.active_member
    redirect_to proposal_path(@info.group.name, @statement.id)
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
    @statement = @info.group.create_statement(current_user, StatementTypes[:update])
    redirect_with_validation_flash(@statement, request.referer) if !@statement.valid?
  end

  def update_creates
    update = Update.create(statement_id: @statement.id, update_text: params[:update][:update])
    @statement.destroy and render_with_validation_flash(update, action: :index) if !update.valid?
  end

end
