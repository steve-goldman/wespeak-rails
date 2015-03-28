class ChangeLifespanToExpiresAtInStatements < ActiveRecord::Migration
  def change
    remove_column :statements, :lifespan
    add_column    :statements, :expires_at, :datetime
  end
end
