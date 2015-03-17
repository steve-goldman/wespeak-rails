module Settings::GeneralsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS            = FlashMessage.new(:success, "Password has been changed!")

    INCORRECT_PASSWORD = FlashMessage.new(:danger,  "Incorrect password")
    BLANK_PASSWORD     = FlashMessage.new(:danger,  "Password can't be blank")
    NOT_LOGGED_IN      = FlashMessage.new(:danger,  "Must be logged in to access this page")
  end

end
