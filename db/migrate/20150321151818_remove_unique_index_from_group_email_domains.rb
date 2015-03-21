class RemoveUniqueIndexFromGroupEmailDomains < ActiveRecord::Migration
  def change
    remove_index :group_email_domains, [:group_id, :domain]
  end
end
