class AddDomainToEmailAddresses < ActiveRecord::Migration
  def change
    add_column :email_addresses, :domain, :string
  end
end
