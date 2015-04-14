class RemoveInitialFieldsFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :initial_lifespan_rule
    remove_column :groups, :initial_support_needed_rule
    remove_column :groups, :initial_votespan_rule
    remove_column :groups, :initial_votes_needed_rule
    remove_column :groups, :initial_yeses_needed_rule
    remove_column :groups, :initial_inactivity_timeout_rule
    remove_column :groups, :initial_invitations
  end
end
