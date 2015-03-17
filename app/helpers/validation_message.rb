class ValidationMessage < FlashMessage

  include Constants

  def initialize(message)
    super(VALIDATION_FLASH_LEVEL, message)
  end
end
