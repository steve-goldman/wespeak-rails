class CreateActiveMembers2 < ActiveRecord::Migration
  def change
    create_table :active_members2s do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user,  index: true

      t.timestamps null: false
    end
  end
end
