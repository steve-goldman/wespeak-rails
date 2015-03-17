module PasswordResetsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS          = FlashMessage.new(:success,  "Password has been reset!")
    
    EMAIL_SENT       = FlashMessage.new(:info,     "Check your email for the password reset link")

    TOKEN_EXPIRED    = FlashMessage.new(:warning,  "This link has expired")

    EMAIL_MISSING    = FlashMessage.new(:danger,   "Invalid password reset link: email address missing")
    EMAIL_UNKNOWN    = FlashMessage.new(:danger,   "Invalid password reset link: email address not found")
    EMAIL_NOT_ACTIVE = FlashMessage.new(:danger,   "Email address not activated (check email for the activation link)")
    PASSWORD_MISSING = FlashMessage.new(:danger,   "Something went wrong: missing password")
    PASSWORD_BLANK   = FlashMessage.new(:danger,   "Please enter a new password")
  end

end
