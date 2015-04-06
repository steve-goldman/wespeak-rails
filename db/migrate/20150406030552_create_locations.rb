class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :statement, index: true
      t.float :latitude
      t.float :longitude
      t.integer :radius

      t.timestamps null: false
    end
    add_foreign_key :locations, :statements
  end
end
