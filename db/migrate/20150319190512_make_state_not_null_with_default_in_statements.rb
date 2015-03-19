class MakeStateNotNullWithDefaultInStatements < ActiveRecord::Migration
  def change
    change_column_null    :statements, :state, false
    change_column_default :statements, :state, 1
  end
end
