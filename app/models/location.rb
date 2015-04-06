class Location < ActiveRecord::Base

  include GroupsHelper

  belongs_to :statement

  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:    90, allow_nil: true }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to:   180, allow_nil: true }
  validates :radius,    numericality: { greater_than_or_equal_to:    1, less_than_or_equal_to: 10000, allow_nil: true }

  validate :locations

  def Location.static_map_url(latitude, longitude, radius)
    "https://maps.googleapis.com/maps/api/staticmap?markers=#{latitude},#{longitude}&zoom=#{map_zoom(radius)}&size=200x200"
  end

  def Location.map_link(latitude, longitude)
    "https://www.google.com/maps?q=#{latitude},#{longitude}"
  end

  private

  def Location.map_zoom(radius)
    if radius < 1
      12
    else
      [12, (13 - Math.log2(radius)).to_i].min
    end
  end

  def locations
    errors.add(:locations, ValidationMessages::LOCATION_FIELDS.message) if
      (latitude || longitude || radius) && !(latitude && longitude && radius)
  end

end
