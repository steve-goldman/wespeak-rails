class ChangeRadiusToIntegerInGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :radius
    add_column    :groups, :radius, :integer
  end
end
