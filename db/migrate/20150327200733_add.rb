class Add < ActiveRecord::Migration
  def change
    add_column :statements, :support_needed, :integer
    add_column :statements, :eligible_supporters, :integer
  end
end
