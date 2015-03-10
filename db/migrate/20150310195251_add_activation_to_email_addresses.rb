class AddActivationToEmailAddresses < ActiveRecord::Migration
  def change
    add_column :email_addresses, :activation_digest, :string
    add_column :email_addresses, :activated, :boolean, default: false
    add_column :email_addresses, :activated_at, :datetime
  end
end
