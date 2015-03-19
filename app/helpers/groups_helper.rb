module GroupsHelper

  include ApplicationHelper

  class FlashMessages
    SUCCESS              = FlashMessage.new(:success, "Group has been created!")
    
    NOT_LOGGED_IN        = FlashMessage.new(:danger,  "Must be logged in to access this page")
    CANNOT_CREATE_GROUPS = FlashMessage.new(:danger,  "You don't have permission to create groups right now")
    USER_MISMATCH        = FlashMessage.new(:danger,  "Something went wrong: user mismatch")
    GROUP_UNKNOWN        = FlashMessage.new(:danger,  "Something went wrong: group unknown")
    GROUP_ACTIVE         = FlashMessage.new(:danger,  "Active groups can not be configured")
  end

  class ValidationMessages
    include Constants

    NAME_NOT_PRESENT = ValidationMessage.new("Please choose a name")
    NAME_TOO_LONG    = ValidationMessage.new("Name must be less than #{Lengths::GROUP_NAME_MAX} characters")
    NAME_TAKEN       = ValidationMessage.new("That name is already in use")
    NAME_FORMATTING  = ValidationMessage.new("Group names may only contain letters, numbers, underscores, dashes, and periods")
  end
end
