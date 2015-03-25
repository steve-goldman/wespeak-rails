class RemoveUniqueIndexFromSentInvitations < ActiveRecord::Migration
  def change
    remove_index :sent_invitations, [:user_id, :group_id]
  end
end
