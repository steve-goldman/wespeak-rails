class ProfilesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:activate_member]

  before_action :logged_in,        only: [:support, :unsupport, :vote_no, :vote_yes, :activate_member, :deactivate_member, :follow, :unfollow]
  before_action :statement_valid,  only: [:support, :unsupport, :vote_no, :vote_yes]
  before_action :statement_alive,  only: [:support, :unsupport]
  before_action :statement_voting, only: [:vote_no, :vote_yes]
  before_action :does_not_support, only: [:support]
  before_action :does_support,     only: [:unsupport]
  before_action :does_not_vote_no, only: [:vote_no]
  before_action :does_not_vote_yes,only: [:vote_yes]
  before_action :support_eligible, only: [:support, :unsupport]
  before_action :vote_eligible,    only: [:vote_no, :vote_yes]
  before_action :support_creates,  only: [:support]
  before_action :support_destroys, only: [:unsupport]

  before_action only: [:vote_no] do
    vote_creates_or_updates(Votes::NO)
  end
  
  before_action only: [:vote_yes] do
    vote_creates_or_updates(Votes::YES)
  end
  
  def show
    @all_statements     = @info.group.get_all_statements(@info.state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
    @statement_pointers = @info.group.get_statement_pointers

    respond_to do |format|
      format.html
      format.js { render 'group_pages/show_tabs' if params[:page].nil? }
    end
  end

  def support
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  def vote_no
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  def vote_yes
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  def unsupport
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  def activate_member
    @info.make_member_active
    redirect_to request.referer
  end

  def deactivate_member
    @info.make_member_inactive
    redirect_to request.referer
  end

  def follow
    @info.user.follow(@info.group)

    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  def unfollow
    @info.user.unfollow(@info.group)

    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  private

  def logged_in
    redirect_to root_url if @info.user.nil?
  end

  def statement_valid
    @statement = Statement.where(id: params[:statement_id]).where.not(state: StatementStates[:new]).first
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if @statement.nil?
  end

  def statement_alive
    redirect_to request.referer || root_url if @statement.state != StatementStates[:alive]
  end

  def statement_voting
    redirect_to request.referer || root_url if @statement.state != StatementStates[:voting]
    @vote = @statement.user_vote(@info.user)
  end

  def does_not_support
    redirect_to request.referer || root_url if @statement.user_supports?(@info.user)
  end

  def does_support
    redirect_to request.referer || root_url if !@statement.user_supports?(@info.user)
  end

  def does_not_vote_no
    redirect_to request.referer || root_url if @vote && @vote.vote == Votes::NO
  end

  def does_not_vote_yes
    redirect_to request.referer || root_url if @vote && @vote.vote == Votes::YES
  end

  def support_eligible
    redirect_with_flash(FlashMessages::NOT_SUPPORT_ELIGIBLE, request.referer || root_url) if
      !@info.support_eligible?(@statement)
  end

  def vote_eligible
    redirect_with_flash(FlashMessages::NOT_VOTE_ELIGIBLE, request.referer || root_url) if
      !@info.vote_eligible?(@statement)
  end

  def support_creates
    @info.make_member_active
    support = @statement.add_support(@info.user)
    redirect_with_validation_flash(support, request.referer || root_url) if !support.valid?
  end

  def support_destroys
    @info.make_member_active
    @statement.remove_support(@info.user)
  end

  def vote_creates_or_updates(vote)
    @info.make_member_active
    vote = @statement.cast_vote(@info.user, vote)
    redirect_with_validation_flash(vote, request.referer || root_url) if !vote.valid?
  end

end
