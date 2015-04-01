class InvitesController < ApplicationController

  before_action :logged_in, only: [:index]

  def index
    @new_invitations = @user.new_invitations
    @old_invitations = @user.old_invitations
  end

  private

  def logged_in
    @user = current_user
    redirect_to root_url if !logged_in?
  end

end
