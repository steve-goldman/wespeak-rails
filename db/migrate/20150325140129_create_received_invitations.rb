class CreateReceivedInvitations < ActiveRecord::Migration
  def change
    create_table :received_invitations do |t|
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
  end
end
