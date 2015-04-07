class ProfileImagesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :profile_image
  end

  before_action :profile_image_creates,   only: [:create]

  before_action do
    get_of_type(:profile_image, (params[:state] || :alive.to_sym).to_sym)
  end
  
  def new
    render 'group_pages/new'
  end

  def create
    @info.set_state_alive

    respond_to do |format|
      format.html { redirect_to profile_images_path(@info.group.name, :alive) }
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

  def profile_image_creates
    profile_image = ProfileImage.create(statement_id: @statement.id, image: params[:image])
    @statement.destroy and redirect_with_validation_flash(profile_image, request.referer || root_url) if !profile_image.valid?
  end
  
end
