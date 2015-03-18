class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.belongs_to :group,     index: true
      t.belongs_to :user,      index: true
      t.integer    :type,      index: true
      t.integer    :content_id

      t.timestamps null: false
    end
  end
end
