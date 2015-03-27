class TaglinesController < GroupPagesControllerBase
  before_action :enforce_change_eligible, only: [:create]

  before_action :statement_creates,       only: [:create]
  before_action :tagline_creates,         only: [:create]

  def create
    make_member_active @info.group, current_user, @active_member
    redirect_to proposal_path(@info.group.name, @statement.id)
  end

  def index
    @statements = @info.group.get_of_type(:tagline, :alive, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def statement_creates
    @statement = @info.group.create_statement(current_user, StatementTypes[:tagline])
    redirect_with_validation_flash(@statement, request.referer) if !@statement.valid?
  end

  def tagline_creates
    tagline = Tagline.create(statement_id: @statement.id, tagline: params[:tagline][:tagline])
    @statement.destroy and render_with_validation_flash(tagline, action: :index) if !tagline.valid?
  end

end
