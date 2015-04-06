class AddLatitudeLongitudeRadiusToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :latitude, :float
    add_column :groups, :longitude, :float
    add_column :groups, :radius, :float
  end
end
