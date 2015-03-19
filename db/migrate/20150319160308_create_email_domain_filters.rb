class CreateEmailDomainFilters < ActiveRecord::Migration
  def change
    create_table :email_domain_filters do |t|
      t.string :domain
      t.boolean :active

      t.timestamps null: false
    end
  end
end
