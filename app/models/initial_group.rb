class InitialGroup < ActiveRecord::Base
  belongs_to :statement
  has_many   :initial_group_email_domains

  # the profile image
  mount_uploader :profile_image, ImageUploader
end
