class UpdatesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :update
  end

  before_action :update_creates,          only: [:create]

  before_action do
    get_of_type(:update, (params[:state] || :alive.to_s).to_sym)
  end

  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to updates_path(@info.group.name, :alive) }
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

  def update_creates
    update = Update.create(statement_id: @statement.id, update_text: params[:update][:update])
    @statement.destroy and redirect_with_validation_flash(update, request.referer || root_url) if !update.valid?
  end

end
