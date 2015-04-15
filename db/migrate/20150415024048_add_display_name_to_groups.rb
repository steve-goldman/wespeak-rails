class AddDisplayNameToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :display_name, :string
  end
end
