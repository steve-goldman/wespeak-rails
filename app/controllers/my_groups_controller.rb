class MyGroupsController < ApplicationController

  before_action :logged_in, only: [:index]

  def index
    group_ids = "SELECT group_id FROM active_members WHERE user_id = :user_id"
    @my_groups = Group.where("id IN (#{group_ids})", user_id: @user.id)
  end

  private

  def logged_in
    @user = current_user
    redirect_to root_url if !logged_in?
  end

end
