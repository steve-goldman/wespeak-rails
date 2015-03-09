class CreateEmailAddresses < ActiveRecord::Migration
  def change
    create_table :email_addresses do |t|
      t.string :email
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :email_addresses, :users
    add_index :email_addresses, :email
    add_index :email_addresses, :user_id
  end
end
