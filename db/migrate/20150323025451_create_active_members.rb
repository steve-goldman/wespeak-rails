class CreateActiveMembers < ActiveRecord::Migration
  def change
    create_table :active_members do |t|
      t.integer :group_id
      t.integer :user_id
    end
  end
end
