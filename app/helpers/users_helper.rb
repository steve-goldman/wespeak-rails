module UsersHelper

  include ApplicationHelper

  class FlashMessages
    EMAIL_SENT = FlashMessage.new(:info, "Check your email for the email address activation link")
  end

  class ValidationMessages
    include Constants

    NAME_NOT_PRESENT   = ValidationMessage.new("Please choose a name")
    NAME_TOO_LONG      = ValidationMessage.new("Name must be less than #{Lengths::USER_NAME_MAX} characters")
    NAME_TAKEN         = ValidationMessage.new("That name is already in use")

    PASSWORD_NOT_PRESENT     = ValidationMessage.new("Please choose a password")
    PASSWORD_LENGTH          = ValidationMessage.new("Password must be at least #{Lengths::PASSWORD_MIN} characters")
    CONFIRMATION_MISMATCH    = ValidationMessage.new("Password does not match confirmation")
    CONFIRMATION_NOT_PRESENT = ValidationMessage.new("Please confirm your password")

    EMAIL_NOT_PRESENT     = ValidationMessage.new("Please choose an email address")
    EMAIL_TOO_LONG        = ValidationMessage.new("Email address must be less than #{Lengths::EMAIL_ADDR_MAX} characters")
    EMAIL_FORMATTING      = ValidationMessage.new("Email address is invalid")
    EMAIL_TAKEN           = ValidationMessage.new("That email address is already in use")
    EMAIL_MISSING_USER_ID = ValidationMessage.new("Something went wrong: no user for email address")
  end

end
