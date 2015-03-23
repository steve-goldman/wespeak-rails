class AddIndexToStatementIdInTaglines < ActiveRecord::Migration
  def change
    add_index :taglines, :statement_id
  end
end
