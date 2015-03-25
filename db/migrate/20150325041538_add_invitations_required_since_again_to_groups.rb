class AddInvitationsRequiredSinceAgainToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :invitations_required_since, :datetime
  end
end
