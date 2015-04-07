class ProfileImagesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :profile_image
  end

  before_action :profile_image_creates,   only: [:create]

  before_action do
    get_of_type(:profile_image, (params[:state] || :alive.to_sym).to_sym)
  end
  
  private

  def profile_image_creates
    profile_image = ProfileImage.create(statement_id: @statement.id, image: params[:image])
    @statement.destroy and redirect_with_validation_flash(profile_image, request.referer || root_url) if !profile_image.valid?
  end
  
end
