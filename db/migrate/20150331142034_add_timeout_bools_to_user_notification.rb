class AddTimeoutBoolsToUserNotification < ActiveRecord::Migration
  def change
    add_column :user_notifications, :about_to_timeout, :boolean
    add_column :user_notifications, :timed_out,        :boolean
  end
end
