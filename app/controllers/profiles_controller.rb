class ProfilesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:activate_member]

  before_action :logged_in,        only: [:support, :unsupport, :vote_no, :vote_yes, :activate_member, :deactivate_member, :follow, :unfollow]
  before_action :statement_valid,  only: [:support, :unsupport, :vote_no, :vote_yes, :why_not_support_eligible, :why_not_vote_eligible]
  before_action :statement_alive,  only: [:why_not_support_eligible]
  before_action :statement_voting, only: [:why_not_vote_eligibe]
  before_action :support_eligible, only: [:support, :unsupport]
  before_action :vote_eligible,    only: [:vote_no, :vote_yes]

  def show
    @support_order      = params[:support_order] ? true : false
    @statements     = @info.group.get_all_statements(@info.state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE, support_order: @support_order)

    respond_to do |format|
      format.html
      format.js { render 'group_pages/show_tabs' if params[:page].nil? }
    end
  end

  def show_participation
  end

  def show_rules
  end

  def support
    ok = @info.change_eligible? &&
         @statement.state == StatementStates[:alive] &&
         !@statement.user_supports?(@info.user)
    
    if ok
      @info.make_member_active
      support = @statement.add_support(@info.user)
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js do
        if ok
          render 'supported_or_voted'
        else
          render 'could_not_support'
        end
      end
    end
  end

  def unsupport
    ok = @info.change_eligible? &&
         @statement.state == StatementStates[:alive] &&
         @statement.user_supports?(@info.user)
    
    if ok
      @info.make_member_active
      @statement.remove_support(@info.user)
    end
    
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js do
        if ok
          render 'supported_or_voted'
        else
          render 'could_not_support'
        end
      end
    end
  end

  def vote_no
    ok = @info.change_eligible? &&
         @statement.state == StatementStates[:voting] &&
         !@statement.user_vote(@info.user)

    if ok
      @info.make_member_active
      vote = @statement.cast_vote(@info.user, Votes::NO)
    end
         
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js do
        if ok
          render 'supported_or_voted'
        else
          render 'could_not_support'
        end
      end
    end
  end

  def vote_yes
    ok = @info.change_eligible? &&
         @statement.state == StatementStates[:voting] &&
         !@statement.user_vote(@info.user)

    if ok
      @info.make_member_active
      vote = @statement.cast_vote(@info.user, Votes::YES)
    end
         
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js do
        if ok
          render 'supported_or_voted'
        else
          render 'could_not_support'
        end
      end
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

  def why_not_support_eligible
  end

  def why_not_vote_eligible
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
  end

  def support_eligible
    redirect_with_flash(FlashMessages::NOT_SUPPORT_ELIGIBLE, request.referer || root_url) if
      !@info.support_eligible?(@statement)
  end

  def vote_eligible
    redirect_with_flash(FlashMessages::NOT_VOTE_ELIGIBLE, request.referer || root_url) if
      !@info.vote_eligible?(@statement)
  end

end
