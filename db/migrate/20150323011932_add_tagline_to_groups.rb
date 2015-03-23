class AddTaglineToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :tagline, :text
  end
end
