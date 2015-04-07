class TaglinesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :tagline
  end
  
  before_action :tagline_creates,         only: [:create]

  before_action do
    get_of_type(:tagline, (params[:state] || :alive.to_s).to_sym)
  end

  def new
    render 'group_pages/new'
  end

  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to taglines_path(@info.group.name, :alive) }
      format.js   { render 'group_pages/show_tabs' }
    end
  end

  def index
    respond_to do |format|
      format.html { render 'group_pages/index' }
      format.js   { render params[:page].nil? ? 'group_pages/show_tabs' : 'group_pages/show_next_page' }
    end
  end

  private

  def tagline_creates
    tagline = Tagline.create(statement_id: @statement.id, tagline: params[:tagline][:tagline])
    @statement.destroy and redirect_with_validation_flash(tagline, request.referer || root_url) if !tagline.valid?
  end

end
