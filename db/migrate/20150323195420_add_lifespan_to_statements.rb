class AddLifespanToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :lifespan, :integer
  end
end
