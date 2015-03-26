class ProposalsController < GroupPagesControllerBase

  include GroupsHelper

  before_action :statement_found,     only: [:show]

  def index
    @all_statements     = @info.group.get_all_statements(:alive, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
    @statement_pointers = @info.group.get_statement_pointers

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  private

  def statement_found
    @statement = Statement.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if @statement.nil?
  end
end
