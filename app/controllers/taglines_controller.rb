class TaglinesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :tagline
  end
  
  before_action :tagline_creates,         only: [:create]

  before_action do
    get_of_type(:tagline, (params[:state] || :alive.to_s).to_sym)
  end

  private

  def tagline_creates
    tagline = Tagline.create(statement_id: @statement.id, tagline: params[:tagline][:tagline])
    @statement.destroy and redirect_with_validation_flash(tagline, request.referer || root_url) if !tagline.valid?
  end

end
