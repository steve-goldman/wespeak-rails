module Constants
  class Lengths
    USER_NAME_MAX = 50
    PASSWORD_MIN  = 6
  end

  class Regex
    EMAIL = VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end
end
