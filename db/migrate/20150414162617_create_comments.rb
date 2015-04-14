class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :statement, index: true
      t.text :payload

      t.timestamps null: false
    end
  end
end
