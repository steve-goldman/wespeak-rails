class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.references :user, index: true
      t.boolean :vote_begins_active
      t.boolean :vote_ends_active
      t.boolean :vote_begins_following
      t.boolean :vote_ends_following
      t.boolean :support_receipt
      t.boolean :vote_receipt
      t.boolean :my_statement_dies

      t.timestamps null: false
    end
  end
end
