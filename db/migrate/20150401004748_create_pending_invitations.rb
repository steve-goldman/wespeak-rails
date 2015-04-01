class CreatePendingInvitations < ActiveRecord::Migration
  def change
    create_table :pending_invitations do |t|
      t.string :email
      t.references :group, index: true

      t.timestamps null: false
    end
    add_index :pending_invitations, [:email, :group_id], unique: true
  end
end
