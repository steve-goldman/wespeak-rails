class TaglinesController < GroupPagesControllerBase
  before_action :group_found,             only: [:create, :index]
  before_action :is_active_member,        only: [:create, :index]
  before_action :email_eligible,          only: [:create, :index]
  before_action :change_eligible,         only: [:create, :index]
  before_action :enforce_change_eligible, only: [:create]

  before_action :statement_creates,       only: [:create]
  before_action :tagline_creates,         only: [:create]

  def create
    if @active_member
      @active_member.extend_active @group.inactivity_timeout_rule
    else
      @group.active_members.create(user_id: current_user.id,
                                   active_seconds: @group.inactivity_timeout_rule)
    end
    redirect_to proposal_path(@group.name, @statement.id)
  end

  def index
    @statements = @group.get_of_type(:tagline, :alive, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def statement_creates
    @statement = @group.create_statement(current_user, StatementTypes[:tagline])
    redirect_with_validation_flash(@statement, request.referer) if !@statement.valid?
  end

  def tagline_creates
    tagline = Tagline.create(statement_id: @statement.id, tagline: params[:tagline][:tagline])
    @statement.destroy and render_with_validation_flash(tagline, action: :index) if !tagline.valid?
  end

end
