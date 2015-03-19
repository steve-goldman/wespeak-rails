class UndoLastMigrationInStatements < ActiveRecord::Migration
  def change
    change_column_null    :statements, :state, true
    change_column_default :statements, :state, nil
  end
end
