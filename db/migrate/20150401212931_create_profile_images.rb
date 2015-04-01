class CreateProfileImages < ActiveRecord::Migration
  def change
    create_table :profile_images do |t|
      t.references :statement, index: true
      t.string :image

      t.timestamps null: false
    end
  end
end
