module EmailAddressActivationsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS              = FlashMessage.new(:success, "Email address activated!")
    
    EMAIL_MISSING        = FlashMessage.new(:danger,  "Invalid activation link: missing email address")
    EMAIL_UNKNOWN        = FlashMessage.new(:danger,  "Invalid activation link: unknown email address")
    EMAIL_ALREADY_ACTIVE = FlashMessage.new(:warning, "This email address is already active")
    TOKEN_INVALID        = FlashMessage.new(:danger,  "Invalid activation link: bad token")
    PASSWORD_INCORRECT   = FlashMessage.new(:danger,  "Incorrect password")
  end

end
