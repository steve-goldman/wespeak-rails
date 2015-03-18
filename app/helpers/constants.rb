module Constants
  class Lengths
    USER_NAME_MAX  = 50
    PASSWORD_MIN   = 6
    PASSWORD_MAX   = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED 
    EMAIL_ADDR_MAX = 255
    GROUP_NAME_MAX = 64
  end

  class Regex
    EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    GROUP = /\A[\w+\-.]+\z/i
  end

  class ExpirationTimes
    PASSWORD_RESET_EXPIRATION_HOURS = 2
    
    def ExpirationTimes.password_reset_expiration
      PASSWORD_RESET_EXPIRATION_HOURS.hours.ago
    end
  end

  VALIDATION_FLASH_LEVEL = :danger
  
end
