class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
  end
end
