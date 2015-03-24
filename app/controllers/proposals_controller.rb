class ProposalsController < GroupPagesControllerBase

  include GroupsHelper

  before_action :group_found,        only: [:index, :show]
  before_action :is_active_member,   only: [:index, :show]
  before_action :email_eligible,     only: [:index, :show]
  before_action :change_eligible,    only: [:index, :show]

  before_action :statement_found,     only: [:show]

  def index
    @all_statements     = @group.get_all_statements(:alive, params[:page])
    @statement_pointers = @group.get_statement_pointers
  end

  def show
  end

  private

  def statement_found
    @statement = Statement.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if @statement.nil?
  end
end
