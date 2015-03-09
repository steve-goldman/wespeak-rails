class RenameToPrimaryEmailAddressIdInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :primary_email, :primary_email_address_id
  end
end
