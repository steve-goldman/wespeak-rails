class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.references :statement, index: true
      t.integer :rule_type
      t.integer :rule_value

      t.timestamps null: false
    end
  end
end
