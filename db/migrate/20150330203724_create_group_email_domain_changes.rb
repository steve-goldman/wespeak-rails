class CreateGroupEmailDomainChanges < ActiveRecord::Migration
  def change
    create_table :group_email_domain_changes do |t|
      t.references :statement, index: true
      t.string :domain
      t.boolean :included

      t.timestamps null: false
    end
  end
end
