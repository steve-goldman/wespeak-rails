class DropActiveMembers < ActiveRecord::Migration
  def change
    drop_table :active_members
  end
end
