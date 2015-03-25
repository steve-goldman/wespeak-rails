class AddInvitationsRequiredSinceToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :invitations_required_since, :time
  end
end
