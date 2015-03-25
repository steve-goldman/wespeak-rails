class AddUniqueIndexAgainToReceivedInvitations < ActiveRecord::Migration
  def change
    add_index :received_invitations, [:user_id, :group_id], unique: true
  end
end
