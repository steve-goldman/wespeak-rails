class AddProfileImageToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :profile_image, :string
  end
end
