class AddTaglineToInitialGroup < ActiveRecord::Migration
  def change
    add_column :initial_groups, :tagline, :text
  end
end
