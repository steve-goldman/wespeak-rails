class AddMoreFieldsToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :expired_at,      :datetime
    add_column :statements, :vote_began_at,   :datetime
    add_column :statements, :vote_ends_at,    :datetime
    add_column :statements, :vote_ended_at,   :datetime
    add_column :statements, :votes_needed,    :integer
    add_column :statements, :eligible_voters, :integer
    add_column :statements, :yeses_needed,    :integer
  end
end
