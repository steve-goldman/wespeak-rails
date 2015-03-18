class ChangeTypeToStatementType < ActiveRecord::Migration
  def change
    rename_column :statements, :type, :statement_type
  end
end
