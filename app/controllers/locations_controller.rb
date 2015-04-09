class LocationsController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create, :create_rem_locations] do
    statement_creates :location
  end

  before_action only: [:create] do
    location_creates(:add, params[:location][:latitude], params[:location][:longitude], params[:location][:radius])
  end

  before_action only: [:create_rem_locations] do
    location_creates(:remove_all, nil, nil, nil)
  end

  before_action do
    get_of_type(:location, (params[:state] || :alive.to_sym).to_sym)
  end

  def create_rem_locations
    create
  end
  
  private

  def location_creates(change_type, latitude, longitude, radius)
    location = Location.create(statement_id: @statement.id,
                               change_type:  LocationChangeTypes[change_type],
                               latitude:     latitude,
                               longitude:    longitude,
                               radius:       radius)
    @statement.destroy and redirect_with_validation_flash(location, request.referer || root_url) if !location.valid?
  end
  
end
