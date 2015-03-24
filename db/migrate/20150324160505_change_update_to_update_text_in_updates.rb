class ChangeUpdateToUpdateTextInUpdates < ActiveRecord::Migration
  def change
    rename_column :updates, :update, :update_text
  end
end
