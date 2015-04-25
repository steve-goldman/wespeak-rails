class UserImage < ActiveRecord::Base

  include GroupsHelper

  mount_uploader :image, ImageUploader
  
  belongs_to :user

  def validation_keys
    [:image, :image_size, :user_id]
  end

  validates :image, { presence: { message: ValidationMessages::IMAGE_NOT_PRESENT.message } }

  validate  :image_size
  
  validates :user_id, { presence: { message: ValidationMessages::USER_ID_NOT_PRESENT.message } }

  private

  def image_size
    errors.add(:image_size, ValidationMessages::IMAGE_TOO_LARGE.message) if image.size > Sizes::IMAGE_FILE_MAX
  end
end
