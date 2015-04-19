class UserLocationsController < ApplicationController
  def create
    current_user.push_location params[:coords][:latitude],
                               params[:coords][:longitude],
                               params[:coords][:accuracy]
    head :ok
  end
end
