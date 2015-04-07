class AddConfirmedToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :confirmed, :boolean
  end
end
