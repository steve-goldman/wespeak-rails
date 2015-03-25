class AddIndexToSentInvitations < ActiveRecord::Migration
  def change
    add_index :sent_invitations, [:user_id, :group_id, :created_at]
  end
end
