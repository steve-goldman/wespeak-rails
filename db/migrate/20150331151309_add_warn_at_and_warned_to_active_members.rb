class AddWarnAtAndWarnedToActiveMembers < ActiveRecord::Migration
  def change
    add_column :active_members, :warn_at, :datetime
    add_column :active_members, :warned,  :boolean
  end
end
