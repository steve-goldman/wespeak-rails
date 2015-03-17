module PasswordResetsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS         = FlashMessage.new(:success,  "Password has been reset!")
    
    EMAIL_SENT      = FlashMessage.new(:info,     "Check your email for the password reset link")

    EXPIRED_LINK    = FlashMessage.new(:warning,  "This link has expired")

    EMAIL_UNKNOWN   = FlashMessage.new(:danger,   "Email address not found")
    BLANK_PASSWORD  = FlashMessage.new(:danger,   "Password can't be blank")
    INVALID_LINK    = FlashMessage.new(:danger,   "Invalid password reset link")
  end

end
