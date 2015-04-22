class ProposalsController < GroupPagesControllerBase

  include GroupsHelper

  before_action :statement_valid,      only: [:show]

  before_action :logged_in,            only: [:confirm, :confirmed, :discarded, :create_comment, :destroy_comment]

  before_action :user_matches,         only: [:confirm, :confirmed, :discarded]
  before_action :statement_confirms,   only: [:confirmed]
  before_action :statement_discards,   only: [:discarded]

  before_action :user_and_statement_matches, only: [:create_comment]
  before_action :user_eligible,              only: [:create_comment]
  before_action :comment_creates,            only: [:create_comment]

  before_action :comment_valid,              only: [:destroy_comment]
  before_action :not_already_deleted,        only: [:destroy_comment]
  before_action :user_owns_comment,          only: [:destroy_comment]
  before_action :comment_destroys,           only: [:destroy_comment]

  def show
    @feed = params[:feed] == "true"
    @comments = @statement.comments.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
                .order(:id)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def confirm
    render 'group_pages/confirm'
  end

  def confirmed
    redirect_with_flash(FlashMessages::PROPOSAL_SUCCESS, statement_path(@info.group.name, @statement.id))
  end

  def discarded
    redirect_with_flash(FlashMessages::PROPOSAL_DISCARDED, group_profile_path(@info.group.name))
  end

  def create_comment
    redirect_with_flash(FlashMessages::COMMENT_SUCCESS, statement_path(@info.group.name, @statement.id))
  end

  def destroy_comment
    redirect_with_flash(FlashMessages::COMMENT_DELETE_SUCCESS, statement_path(@info.group.name, @comment.statement.id))
  end

  private

  def statement_valid
    @statement = Statement.where(id: params[:id]).where.not(state: StatementStates[:new]).first
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if !@statement
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

  def user_and_statement_matches
    @statement = Statement.find_by(id: params[:statement_id])
    if @statement.nil?
      redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url)
    elsif current_user.id != @info.user.id
      redirect_with_flash(FlashMessages::USER_MISMATCH, request.referer || root_url)
    elsif @statement.group.id != @info.group.id
      redirect_with_flash(FlashMessages::GROUP_MISMATCH, request.referer || root_url)
    end
  end

  def user_eligible
    redirect_with_flash(FlashMessages::NOT_CHANGE_ELIGIBLE, request.referer || root_url) if !@info.change_eligible?
  end

  def comment_creates
    @comment = Comment.create(statement_id: @statement.id, user_id: @info.user.id, payload: params[:comment][:payload])
    redirect_with_validation_flash(@comment, request.referer || root_url) if !@comment.valid?
  end

  def user_owns_comment
    redirect_with_flash(FlashMessages::USER_MISMATCH, request.referer || root_url) if @comment.user.id != @info.user.id
  end

  def comment_valid
    @comment = Comment.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::COMMENT_UNKNOWN, request.referer || root_url) if @comment.nil?
  end

  def not_already_deleted
    redirect_with_flash(FlashMessages::ALREADY_DELETED, request.referer || root_url) if @comment.deleted
  end

  def comment_destroys
    @comment.update_attributes(deleted: true)
  end

  def logged_in
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, request.referer || root_url) if !@info.user
  end
end
