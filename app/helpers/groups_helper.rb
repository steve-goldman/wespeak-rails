module GroupsHelper

  include ApplicationHelper

  class FlashMessages
    ACTIVATED_SUCCESS    = FlashMessage.new(:success, "Group created!")
    UPDATE_SUCCESS       = FlashMessage.new(:success, "Group rules updated!")
    UPDATE_INVITATIONS_SUCCESS = FlashMessage.new(:success, "Invitations settings updated!")
    INVITATION_SENT      = FlashMessage.new(:success, "Invitation sent!")
    
    NOT_LOGGED_IN        = FlashMessage.new(:danger,  "Must be logged in to access this page")
    CANNOT_CREATE_GROUPS = FlashMessage.new(:danger,  "You don't have permission to create groups right now")
    USER_MISMATCH        = FlashMessage.new(:danger,  "Something went wrong: user mismatch")
    GROUP_UNKNOWN        = FlashMessage.new(:danger,  "Something went wrong: group unknown")
    GROUP_ACTIVE         = FlashMessage.new(:danger,  "Active groups cannot be configured")
    GROUP_NOT_ACTIVE     = FlashMessage.new(:danger,  "This group has not been configured")
    DOMAIN_UNKNOWN       = FlashMessage.new(:danger,  "Something went wrong: domain unknown")
    NOT_CHANGE_ELIGIBLE  = FlashMessage.new(:danger,  "You're not eligible to participate")
    STATEMENT_UNKNOWN    = FlashMessage.new(:danger,  "Something went wrong: proposal unknown")
    NO_INVITES           = FlashMessage.new(:danger,  "You have no more invites today, try again tomorrow")
  end

  class ValidationMessages
    include Constants

    NAME_NOT_PRESENT = ValidationMessage.new("Please choose a name")
    NAME_TOO_LONG    = ValidationMessage.new("Name must be less than #{Lengths::GROUP_NAME_MAX} characters")
    NAME_TAKEN       = ValidationMessage.new("That name is already in use")
    NAME_FORMATTING  = ValidationMessage.new("Group names may only contain letters, numbers, underscores, and dashes")

    DOMAIN_NOT_PRESENT = ValidationMessage.new("Please choose a domain")
    DOMAIN_TOO_LONG    = ValidationMessage.new("Domain must be less than #{Lengths::EMAIL_DOMAIN_MAX} characters")
    DOMAIN_FORMATTING  = ValidationMessage.new("That is not a valid email domain")

    LIFESPAN_DURATION  = ValidationMessage.new("Lifespan must be between #{Timespans.in_words(Timespans::LIFESPAN_MIN)} and #{Timespans.in_words(Timespans::LIFESPAN_MAX)}")
    VOTESPAN_DURATION  = ValidationMessage.new("Vote lifespan must be between #{Timespans.in_words(Timespans::VOTESPAN_MIN)} and #{Timespans.in_words(Timespans::VOTESPAN_MAX)}")
    INACTIVITY_TIMEOUT_DURATION  = ValidationMessage.new("Member inactivity timeout must be between #{Timespans.in_words(Timespans::INACTIVITY_TIMEOUT_MIN)} and #{Timespans.in_words(Timespans::INACTIVITY_TIMEOUT_MAX)}")

    SUPPORT_NEEDED_BOUNDS = ValidationMessage.new("Support needed must be between #{Needed::SUPPORT_MIN} and #{Needed::SUPPORT_MAX}")
    VOTES_NEEDED_BOUNDS   = ValidationMessage.new("Votes needed must be between #{Needed::VOTES_MIN} and #{Needed::VOTES_MAX}")
    YESES_NEEDED_BOUNDS   = ValidationMessage.new("Yeses needed must be between #{Needed::YESES_MIN} and #{Needed::YESES_MAX}")

    INVITATIONS_BOUNDS = ValidationMessage.new("Invitations must be between 0 and #{Invitations::MAX_PER_DAY}")

    TAGLINE_NOT_PRESENT = ValidationMessage.new("Please write a tagline")
    TAGLINE_TOO_LONG    = ValidationMessage.new("Please limit the length to #{Lengths::TAGLINE_MAX} characters")

    UPDATE_NOT_PRESENT = ValidationMessage.new("Please write an update")
    UPDATE_TOO_LONG    = ValidationMessage.new("Please limit the length to #{Lengths::UPDATE_MAX} characters")

    STATEMENT_ID_NOT_PRESENT = ValidationMessage.new("Something went wrong: no statement id")
  end
end
