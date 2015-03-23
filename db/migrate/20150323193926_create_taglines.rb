class CreateTaglines < ActiveRecord::Migration
  def change
    create_table :taglines do |t|
      t.text :tagline

      t.timestamps null: false
    end
  end
end
