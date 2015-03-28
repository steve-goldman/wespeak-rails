class ProfilesController < GroupPagesControllerBase

  before_action :enforce_change_eligible, only: [:activate_member]

  before_action :statement_valid,  only: [:support, :unsupport]
  before_action :statement_alive,  only: [:support, :unsupport]
  before_action :does_not_support, only: [:support]
  before_action :does_support,     only: [:unsupport]
  before_action :support_eligible, only: [:support, :unsupport]
  before_action :support_creates,  only: [:support]
  before_action :support_destroys, only: [:unsupport]

  def show
    @all_statements     = @info.group.get_all_statements(@info.state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
    @statement_pointers = @info.group.get_statement_pointers

    respond_to do |format|
      format.html
      format.js { render 'show_tabs' if params[:page].nil? }
    end
  end

  def support
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

  private

  def statement_valid
    @statement = Statement.find_by(id: params[:statement_id])
    redirect_with_flash(FlashMessages::STATEMENT_UNKNOWN, request.referer || root_url) if @statement.nil?
  end

  def statement_alive
    redirect_to request.referer || root_url if @statement.state != StatementStates[:alive]
  end

  def does_not_support
    redirect_to request.referer || root_url if @statement.user_supports?(@info.user)
  end

  def does_support
    redirect_to request.referer || root_url if !@statement.user_supports?(@info.user)
  end

  def support_eligible
    redirect_with_flash(FlashMessages::NOT_SUPPORT_ELIGIBLE, request.referer || root_url) if
      !@info.support_eligible?(@statement)
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

end
