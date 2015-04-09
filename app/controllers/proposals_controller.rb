class ProposalsController < GroupPagesControllerBase

  include GroupsHelper

  before_action :statement_valid,      only: [:show]
  before_action :statement_type_valid, only: [:show]
  before_action :content_valid,        only: [:show]

  before_action :user_matches,         only: [:confirm, :confirmed, :discarded]
  before_action :statement_confirms,   only: [:confirmed]
  before_action :statement_discards,   only: [:discarded]

  def show
    @statement_pointer = { statement_type: @key, content: @content }
  end

  def confirm
    render 'group_pages/confirm'
  end

  def confirmed
    @info.make_member_active
    redirect_with_flash(FlashMessages::PROPOSAL_SUCCESS, statement_path(@info.group.name, @statement.id))
  end

  def discarded
    redirect_with_flash(FlashMessages::PROPOSAL_DISCARDED, group_profile_path(@info.group.name))
  end

  private

  def statement_valid
    @statement = Statement.where(id: params[:id]).where.not(state: StatementStates[:new]).first
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

  def user_matches
    @statement = Statement.find_by(id: params[:id], state: StatementStates[:new])
    if @statement.nil?
      redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url)
    elsif @statement.user_id != @info.user.id
      redirect_with_flash(FlashMessages::USER_MISMATCH, request.referer || root_url)
    end
    @statement_tab = StatementTypes.sym(@statement.statement_type).to_s.pluralize.to_sym
  end

  def statement_confirms
    redirect_with_flash(FlashMessages::COULD_NOT_CONFIRM, group_profile_path(@info.group.name)) if !@statement.confirm
  end

  def statement_discards
    redirect_with_flash(FlashMessages::COULD_NOT_DISCARD, group_profile_path(@info.group.name)) if !@statement.discard
  end
end
