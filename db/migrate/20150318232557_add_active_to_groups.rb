class AddActiveToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :active, :boolean, default: false
  end
end
