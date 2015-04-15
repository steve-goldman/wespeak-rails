class CreateDisplayNames < ActiveRecord::Migration
  def change
    create_table :display_names do |t|
      t.references :statement, index: true
      t.string :display_name

      t.timestamps null: false
    end
  end
end
