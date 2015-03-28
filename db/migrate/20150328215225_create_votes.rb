class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.references :statement, index: true
      t.integer :vote

      t.timestamps null: false
    end
  end
end
