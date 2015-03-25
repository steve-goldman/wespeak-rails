class AddUniqueIndexToGroupEmailDomains < ActiveRecord::Migration
  def change
    add_index :group_email_domains, [:group_id, :domain], unique: true
  end
end
