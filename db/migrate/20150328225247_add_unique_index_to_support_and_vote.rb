class AddUniqueIndexToSupportAndVote < ActiveRecord::Migration
  def change
    add_index :supports, [:statement_id, :user_id], unique: true
    add_index :votes,    [:statement_id, :user_id], unique: true
  end
end
