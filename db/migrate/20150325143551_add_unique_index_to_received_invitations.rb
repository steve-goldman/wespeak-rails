class AddUniqueIndexToReceivedInvitations < ActiveRecord::Migration
  def change
    add_index :sent_invitations, [:user_id, :group_id], unique: true
  end
end
