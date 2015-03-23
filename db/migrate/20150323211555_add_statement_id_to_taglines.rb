class AddStatementIdToTaglines < ActiveRecord::Migration
  def change
    add_column :taglines, :statement_id, :integer, index: true
  end
end
