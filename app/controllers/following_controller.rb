class FollowingController < ApplicationController

  before_action :logged_in, only: [:index]

  def index
    group_ids = "SELECT group_id FROM followers WHERE user_id = :user_id"
    @following_groups = Group.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_RECORDS_PER_PAGE).where("id IN (#{group_ids})", user_id: @user.id)
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
