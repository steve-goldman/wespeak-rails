module Settings::EmailIdentitiesHelper

  include ApplicationHelper

  class FlashMessages
    EMAIL_SENT           = FlashMessage.new(:info,    "Please check your email to activate this email address")

    NOT_LOGGED_IN        = FlashMessage.new(:danger,  "Must be logged in to access this page")
    USER_MISMATCH        = FlashMessage.new(:danger,  "Something went wrong: user mismatch")
    EMAIL_MISMATCH       = FlashMessage.new(:danger,  "Something went wrong: email address mismatch")
    CANNOT_DO_TO_PRIMARY = FlashMessage.new(:danger, "Cannot do this action on primary email address")
    EMAIL_NOT_ACTIVATED  = FlashMessage.new(:danger,  "Email address not activated (check email for activation link)")
  end

end
