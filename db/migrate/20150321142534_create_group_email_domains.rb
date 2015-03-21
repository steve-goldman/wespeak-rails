class CreateGroupEmailDomains < ActiveRecord::Migration
  def change
    create_table :group_email_domains do |t|
      t.integer :group_id, index: true
      t.string :domain

      t.timestamps null: false
    end

    add_index :group_email_domains, [:group_id, :domain], unique: true
  end
end
