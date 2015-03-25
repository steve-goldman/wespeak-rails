class RemoveInvitationsRequiredSinceToGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :invitations_required_since
  end
end
