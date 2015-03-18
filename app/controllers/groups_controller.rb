class GroupsController < ApplicationController

  include GroupsHelper

  before_action :logged_in, only: [:new, :create]

  def new
  end

  def create
  end

  private

  def logged_in
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if !logged_in?
  end
end
