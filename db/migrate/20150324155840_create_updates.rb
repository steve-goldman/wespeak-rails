class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.text :update
      t.references :statement, index: true

      t.timestamps null: false
    end
  end
end
