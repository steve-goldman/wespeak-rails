class TaglinesController < GroupPagesControllerBase
  before_action :group_found,             only: [:new, :create]
  before_action :is_active_member,        only: [:new, :create]
  before_action :email_eligible,          only: [:new, :create]
  before_action :change_eligible,         only: [:new, :create]
  before_action :enforce_change_eligible, only: [:new, :create]

  before_action :tagline_creates,         only: [:create]
  before_action :statement_creates,       only: [:create]

  def new
  end

  def create
    redirect_to proposal_path(@group.name, @statement.id)
  end

  def index
  end

  private

  def tagline_creates
    @tagline = Tagline.create(tagline: params[:tagline][:tagline])
    render_with_validation_flash(@tagline, action: :new) if !@tagline.valid?
  end

  def statement_creates
    @statement = @group.create_statement(current_user, StatementTypes[:tagline], @tagline.id)
    redirect_with_validation_flash(@statement, request.referer) if !@statement.valid?
  end
end
