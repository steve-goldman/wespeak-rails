module StatementsHelper

  include ApplicationHelper

  class ValidationMessages
    TYPE_INVALID  = ValidationMessage.new("Something went wrong: invalid type")
    STATE_INVALID = ValidationMessage.new("Something went wrong: invalid state")
  end
end
