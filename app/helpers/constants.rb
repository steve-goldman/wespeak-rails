module Constants
  class Lengths
    USER_NAME_MAX    = 50
    PASSWORD_MIN     = 6
    PASSWORD_MAX     = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED 
    EMAIL_ADDR_MAX   = 255
    EMAIL_DOMAIN_MAX = 255
    GROUP_NAME_MAX   = 64
  end

  class Regex
    EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    EMAIL_DOMAIN = /\A[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    GROUP = /\A[\w+\-.]+\z/i
  end

  class ExpirationTimes
    PASSWORD_RESET_EXPIRATION_HOURS = 2
    
    def ExpirationTimes.password_reset_expiration
      PASSWORD_RESET_EXPIRATION_HOURS.hours.ago
    end
  end

  VALIDATION_FLASH_LEVEL = :danger

  TIMESPAN_INPUT_OPTIONS = [
    ["15 minutes", 15.minutes.to_i],
    ["30 minutes", 30.minutes.to_i],
    ["1 hour"    , 1.hour.to_i],
    ["3 hours"   , 3.hours.to_i],
    ["6 hours"   , 6.hours.to_i],
    ["12 hours"  , 12.hours.to_i],
    ["1 day"     , 1.day.to_i],
    ["2 days"    , 2.days.to_i],
    ["3 days"    , 3.days.to_i],
    ["4 days"    , 4.days.to_i],
    ["5 days"    , 5.days.to_i],
    ["6 days"    , 6.days.to_i],
    ["7 days"    , 7.days.to_i],
  ];
end
