class FixActiveMembersTableName < ActiveRecord::Migration
  def change
    rename_table :active_members2s, :active_members
  end
end
