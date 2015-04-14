class CreateInitialGroups < ActiveRecord::Migration
  def change
    create_table :initial_groups do |t|
      t.references :statement, index: true
      t.integer :lifespan_rule
      t.integer :support_needed_rule
      t.integer :votespan_rule
      t.integer :votes_needed_rule
      t.integer :yeses_needed_rule
      t.integer :inactivity_timeout_rule
      t.integer :invitations
      t.float :latitude
      t.float :longitude
      t.integer :radius

      t.timestamps null: false
    end
    add_foreign_key :initial_groups, :statements
  end
end
