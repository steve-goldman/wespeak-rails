class RenameRuleColumnsInGroups < ActiveRecord::Migration
  def change
    rename_column :groups, :support_needed, :support_needed_rule
    rename_column :groups, :votespan, :votespan_rule
    rename_column :groups, :votes_needed, :votes_needed_rule
    rename_column :groups, :yeses_needed, :yeses_needed_rule
    add_column    :groups, :inactivity_timeout_rule, :integer
  end
end
