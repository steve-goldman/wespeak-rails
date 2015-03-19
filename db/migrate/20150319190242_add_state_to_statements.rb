class AddStateToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :state, :integer, index: true
  end
end
