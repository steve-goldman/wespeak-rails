module UsersHelper

  include ApplicationHelper

  class FlashMessages
    EMAIL_SENT = FlashMessage.new(:info, "Check your email for the email address activation link")
  end

end
