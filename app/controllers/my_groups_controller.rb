class MyGroupsController < ApplicationController

  before_action :logged_in, only: [:index]

  def index
    @my_groups = Group.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
                 .joins(:active_members)
                 .where(active_members: { user_id: @user.id })
                 .order("active_members.updated_at DESC")
    respond_to do |format|
      format.html
      format.js
    end

  end

  private

  def logged_in
    @user = current_user
    redirect_to root_url if !logged_in?
  end

end
