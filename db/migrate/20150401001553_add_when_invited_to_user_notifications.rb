class AddWhenInvitedToUserNotifications < ActiveRecord::Migration
  def change
    add_column :user_notifications, :when_invited, :boolean
  end
end
