class CreateInitialGroupEmailDomains < ActiveRecord::Migration
  def change
    create_table :initial_group_email_domains do |t|
      t.references :initial_group, index: true
      t.references :group_email_domain, index: true

      t.timestamps null: false
    end
    add_foreign_key :initial_group_email_domains, :initial_groups
    add_foreign_key :initial_group_email_domains, :group_email_domains
  end
end
