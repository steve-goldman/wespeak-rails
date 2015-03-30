class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :statement, index: true
      t.integer :invitations

      t.timestamps null: false
    end
  end
end
