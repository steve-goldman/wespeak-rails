class ProposalsController < GroupPagesControllerBase

  include GroupsHelper

  before_action :statement_valid,      only: [:show]
  before_action :statement_type_valid, only: [:show]
  before_action :content_valid,        only: [:show]

  def show
    @statement_pointer = { statement_type: @key, content: @content }
  end

  private

  def statement_valid
    @statement = Statement.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if !@statement
  end

  def statement_type_valid
    @key = StatementTypes.sym(@statement.statement_type)
    redirect_with_flash(FlashMessages::STATEMENT_TYPE_UNKNOWN, request.referer || root_url) if
      !StatementTypes.key?(@key)
  end

  def content_valid
    @content = StatementTypes.table(@key).find_by(statement_id: @statement.id)
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if !@content
  end
end
