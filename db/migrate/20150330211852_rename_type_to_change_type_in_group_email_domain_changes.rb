class RenameTypeToChangeTypeInGroupEmailDomainChanges < ActiveRecord::Migration
  def change
    rename_column :group_email_domain_changes, :type, :change_type
  end
end
