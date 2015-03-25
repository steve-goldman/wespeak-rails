class CreateSentInvitations < ActiveRecord::Migration
  def change
    create_table :sent_invitations do |t|
      t.references :user, index: true
      t.references :group

      t.string :email
      
      t.timestamps null: false
    end

    add_index :sent_invitations, :email
  end
end
