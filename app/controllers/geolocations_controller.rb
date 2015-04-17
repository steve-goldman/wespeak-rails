class GeolocationsController < ApplicationController
  def create
    #Geolocation.new(params).save!
    head :ok
  end
end
