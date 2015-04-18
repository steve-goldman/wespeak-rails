class UserLocation < ActiveRecord::Base
  belongs_to :user

  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:    90, allow_nil: true }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to:   180, allow_nil: true }
  validates :accuracy,  numericality: { greater_than_or_equal_to:    0, allow_nil: true }

end
