module StatementsHelper

  include ApplicationHelper

  class ValidationMessages
    TYPE_INVALID = ValidationMessage.new("Something went wrong: invalid type")
  end
end
