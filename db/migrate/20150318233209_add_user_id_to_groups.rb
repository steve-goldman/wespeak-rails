class AddUserIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :user_id, :integer, index: true
  end
end
