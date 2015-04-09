class AddChangeTypeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :change_type, :integer
    Location.update_all(change_type: LocationChangeTypes[:add])
  end
end
