class AddCreatedAtIndexToStatements < ActiveRecord::Migration
  def change
    add_index :statements, [:group_id, :created_at]
  end
end
