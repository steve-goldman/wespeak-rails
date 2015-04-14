class FollowingController < ApplicationController

  before_action :logged_in, only: [:index]

  def index
    @following_groups = Group.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_RECORDS_PER_PAGE)
                        .joins(:followers)
                        .where(followers: { user_id: @user.id })
                        .order("followers.created_at DESC")
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
