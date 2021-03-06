class StaticPagesController < ApplicationController

  before_action :get_state,      if: :logged_in?
  before_action :get_statements, if: :logged_in?
  
  def home
    respond_to do |format|
      format.html
      format.js { render 'group_pages/show_tabs' if params[:page].nil? }
    end
  end

  def faq
  end

  def privacy_policy
  end

  def terms_of_service
  end

  def contact_us
  end

  private

  def get_state
    redirect_to root_url if params[:state] && !StatementStates.key?(params[:state].to_sym)
    @state = (params[:state] || :accepted.to_s).to_sym
  end

  def get_statements
    following =  current_user.followers.map      { |follower|           follower.group_id }
    active    =  current_user.active_members.map { |active_member| active_member.group_id }
    @group_ids = following + active

    if @group_ids.any?
      @support_order = params[:support_order] ? true : false
      @statements    = Group.get_all_statements(@group_ids, @state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE, support_order: @support_order)
      @infos         = {}
      @statements.each do |statement|
        @infos[statement.group.id] = GroupUserInfo.new(statement.group.name, StatementStates.sym(statement.state), current_user) if !@infos[statement.group.id]
      end
    else
      @statements = nil
      @infos = nil
    end
  end
end
