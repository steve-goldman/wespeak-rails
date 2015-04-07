class RemoveConfirmedFromStatements < ActiveRecord::Migration
  def change
    remove_column :statements, :confirmed
  end
end
