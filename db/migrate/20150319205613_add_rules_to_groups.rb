class AddRulesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :lifespan_rule,  :integer
    add_column :groups, :support_needed, :integer
    add_column :groups, :votespan,       :integer
    add_column :groups, :votes_needed,   :integer
    add_column :groups, :yeses_needed,   :integer
  end
end
