class ProfilesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:activate_member]

  def show
    @state              = (params[:state] || "accepted").to_sym
    @all_statements     = @info.group.get_all_statements(@state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
    @statement_pointers = @info.group.get_statement_pointers

    respond_to do |format|
      format.html
      format.js
    end
  end

  def activate_member
    make_member_active @info.group, @info.user, @info.active_member
    redirect_to request.referer
  end

  def deactivate_member
    make_member_inactive @info.group, @info.user, @info.active_member
    redirect_to request.referer
  end

end
