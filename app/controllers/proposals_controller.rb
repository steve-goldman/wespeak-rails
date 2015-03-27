class ProposalsController < GroupPagesControllerBase

  include GroupsHelper

  def show
    @all_statements     = @info.group.get_all_statements(:alive, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
    @statement_pointers = @info.group.get_statement_pointers

    respond_to do |format|
      format.html
      format.js
    end
  end

end
