class DisplayNamesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:create]

  before_action only: [:create] do
    statement_creates :display_name
  end
  
  before_action :display_name_creates, only: [:create]

  before_action do
    get_of_type(:display_name, (params[:state] || :alive.to_s).to_sym)
  end

  private

  def display_name_creates
    display_name = DisplayName.create(statement_id: @statement.id, display_name: params[:display_name][:display_name])
    @statement.destroy and redirect_with_validation_flash(display_name, request.referer || root_url) if !display_name.valid?
  end

end
