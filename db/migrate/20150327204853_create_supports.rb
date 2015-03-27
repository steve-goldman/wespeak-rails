class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.references :user, index: true
      t.references :statement, index: true

      t.timestamps null: false
    end
  end
end
