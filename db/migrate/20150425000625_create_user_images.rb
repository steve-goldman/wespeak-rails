class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_images do |t|
      t.references :user, index: true
      t.string :image

      t.timestamps null: false
    end
  end
end
