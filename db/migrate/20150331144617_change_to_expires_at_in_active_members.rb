class ChangeToExpiresAtInActiveMembers < ActiveRecord::Migration
  def change
    remove_column :active_members, :active_seconds
    add_column    :active_members, :expires_at, :datetime
  end
end
