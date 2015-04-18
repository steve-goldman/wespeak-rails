class UserLocationsController < ApplicationController
  def create
    location = UserLocation.create(user_id:   current_user.id,
                        latitude:  params[:coords][:latitude],
                        longitude: params[:coords][:longitude],
                        accuracy:  params[:coords][:accuracy])

    head :ok
  end
end
