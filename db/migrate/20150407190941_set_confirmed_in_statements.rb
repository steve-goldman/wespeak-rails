class SetConfirmedInStatements < ActiveRecord::Migration
  def change
    Statement.update_all(confirmed: true)
  end
end
