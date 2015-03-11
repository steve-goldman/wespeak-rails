module Constants
  class Lengths
    USER_NAME_MAX  = 50
    PASSWORD_MIN   = 6
    EMAIL_ADDR_MAX = 255
  end

  class Regex
    EMAIL = VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end

  class ExpirationTimes
    PASSWORD_RESET_EXPIRATION_HOURS = 2
    
    def ExpirationTimes.password_reset_expiration
      PASSWORD_RESET_EXPIRATION_HOURS.hours.ago
    end
  end
  
end
