class AddIndexToEmailDomainFilters < ActiveRecord::Migration
  def change
    add_index :email_domain_filters, [:domain, :active], unique: true
  end
end
