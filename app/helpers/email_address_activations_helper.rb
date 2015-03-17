module EmailAddressActivationsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS            = FlashMessage.new(:success, "Email address activated!")
    
    MISSING_EMAIL      = FlashMessage.new(:danger,  "Invalid activation link: missing email address")
    INVALID_TOKEN      = FlashMessage.new(:danger,  "Invalid activation link: bad token")
    INCORRECT_PASSWORD = FlashMessage.new(:danger,  "Incorrect password")
  end

end
