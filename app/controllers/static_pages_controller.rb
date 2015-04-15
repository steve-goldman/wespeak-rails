class StaticPagesController < ApplicationController

  before_action :get_state,      if: :logged_in?
  before_action :get_statements, if: :logged_in?
  
  def home
    respond_to do |format|
      format.html
      format.js { render 'group_pages/show_tabs' if params[:page].nil? }
    end
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
      @all_statements = Group.get_all_statements(@group_ids, @state, params[:page], params[:per_page] || DEFAULT_RECORDS_PER_PAGE, support_order: @support_order)
      @statement_pointers = Group.get_statement_pointers(@group_ids)
    else
      @all_statements = nil
    end
  end
end
