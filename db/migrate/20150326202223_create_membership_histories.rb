class CreateMembershipHistories < ActiveRecord::Migration
  def change
    create_table :membership_histories do |t|
      t.references :user, index: true
      t.references :group, index: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end
