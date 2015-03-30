class ChangeIncludedToTypeInGroupEmailDomainChanges < ActiveRecord::Migration
  def change
    remove_column :group_email_domain_changes, :included
    add_column :group_email_domain_changes, :type, :integer
  end
end
