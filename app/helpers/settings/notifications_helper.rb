module Settings::NotificationsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS            = FlashMessage.new(:success, "Settings saved!")

    NOT_LOGGED_IN      = FlashMessage.new(:danger,  "Must be logged in to access this page")
  end

end
