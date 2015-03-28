class UpdatesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action :statement_creates,       only: [:create]
  before_action :update_creates,          only: [:create]

  before_action do
    get_of_type(:update, (params[:state] || :alive.to_s).to_sym)
  end

  def create
    make_member_active @info.group, @info.user, @info.active_member

    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to updates_path(@info.group.name, :alive) }
      format.js   { render 'show_tabs' }
    end
  end

  def index
    respond_to do |format|
      format.html
      format.js { render 'show_tabs' if params[:page].nil? }
    end
  end

  private

  def statement_creates
    @statement = @info.group.create_statement(@info.user, StatementTypes[:update])
    redirect_with_validation_flash(@statement, request.referer || root_url) if !@statement.valid?
  end

  def update_creates
    update = Update.create(statement_id: @statement.id, update_text: params[:update][:update])
    @statement.destroy and render_with_validation_flash(update, action: :index) if !update.valid?
  end

end
