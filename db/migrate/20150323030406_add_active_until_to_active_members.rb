class AddActiveUntilToActiveMembers < ActiveRecord::Migration
  def change
    add_column :active_members2s, :active_seconds, :integer
  end
end
