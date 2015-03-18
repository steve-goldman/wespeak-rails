class AddCanCreateGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_create_groups, :boolean, default: false
  end
end
