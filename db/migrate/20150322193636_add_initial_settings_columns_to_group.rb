class AddInitialSettingsColumnsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :initial_lifespan_rule,           :integer
    add_column :groups, :initial_support_needed_rule,     :integer
    add_column :groups, :initial_votespan_rule,           :integer
    add_column :groups, :initial_votes_needed_rule,       :integer
    add_column :groups, :initial_yeses_needed_rule,       :integer
    add_column :groups, :initial_inactivity_timeout_rule, :integer
    add_column :groups, :initial_invitations,             :integer
  end
end
