class AddDisplayNameToInitialGroups < ActiveRecord::Migration
  def change
    add_column :initial_groups, :display_name, :string
  end
end
