class LocationsController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :location
  end

  before_action :location_creates,   only: [:create]

  before_action do
    get_of_type(:location, (params[:state] || :alive.to_sym).to_sym)
  end
  
  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to locations_path(@info.group.name, :alive) }
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

  def location_creates
    location = Location.create(statement_id: @statement.id,
                               latitude:     params[:location][:latitude],
                               longitude:    params[:location][:longitude],
                               radius:       params[:location][:radius])
    @statement.destroy and redirect_with_validation_flash(location, request.referer || root_url) if !location.valid?
  end
  
end
