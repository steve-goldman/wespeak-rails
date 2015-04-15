class AddProfileImageToInitialGroup < ActiveRecord::Migration
  def change
    add_column :initial_groups, :profile_image, :string
  end
end
