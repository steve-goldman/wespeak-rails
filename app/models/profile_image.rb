class ProfileImage < ActiveRecord::Base

  include GroupsHelper

  mount_uploader :image, ImageUploader
  
  belongs_to :statement

  def validation_keys
    [:image, :image_size, :statement_id]
  end

  validates :image, { presence: { message: ValidationMessages::IMAGE_NOT_PRESENT.message } }

  validate  :image_size
  
  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }

  private

  def image_size
    errors.add(:image_size, ValidationMessages::IMAGE_TOO_LARGE.message) if image.size > Sizes::IMAGE_FILE_MAX
  end
end
