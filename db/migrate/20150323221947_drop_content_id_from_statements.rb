class DropContentIdFromStatements < ActiveRecord::Migration
  def change
    remove_column :statements, :content_id
  end
end
