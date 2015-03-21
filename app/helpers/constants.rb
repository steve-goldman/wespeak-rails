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

  class Invitations
    NOT_REQUIRED = -1
    DEFAULT = NOT_REQUIRED
    
    MAX_PER_DAY  = 10

    INPUT_OPTIONS = [
      ["Not required", NOT_REQUIRED],
      ["Members may send 0 per day"   ,  0],
      ["Members may send 1 per day"   ,  1],
      ["Members may send 2 per day"   ,  2],
      ["Members may send 5 per day"   ,  5],
      ["Members may send 10 per day"  , 10],
    ]
  end

  class Timespans
    INPUT_OPTIONS = [
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

    LIFESPAN_MIN           = 15.minutes.to_i
    LIFESPAN_MAX           = 7.days.to_i
    VOTESPAN_MIN           = 15.minutes.to_i
    VOTESPAN_MAX           = 7.days.to_i
    INACTIVITY_TIMEOUT_MIN = 15.minutes.to_i
    INACTIVITY_TIMEOUT_MAX = 7.days.to_i

    def Timespans.in_words(seconds)
      [[60, "second"], [60, "minute"], [24, "hour"], [100000, "day"]].map { |count, name|
        seconds, n = seconds.divmod(count)
        "#{n} #{name}#{n > 1 ? 's' : ''}" if n > 0
      }.compact.reverse.join(' ')
    end
  end

  class Needed
    SUPPORT_MIN = 1
    SUPPORT_MAX = 99
    VOTES_MIN   = 1
    VOTES_MAX   = 99
    YESES_MIN   = 1
    YESES_MAX   = 99
  end
end
