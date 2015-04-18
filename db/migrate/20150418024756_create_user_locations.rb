class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.references :user, index: true
      t.float :latitude
      t.float :longitude
      t.integer :accuracy

      t.timestamps null: false
    end
  end
end
