class AddInvitationsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :invitations, :integer
  end
end
