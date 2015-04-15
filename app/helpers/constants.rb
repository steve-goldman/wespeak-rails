module Constants

  class Lengths
    USER_NAME_MAX    = 50
    PASSWORD_MIN     = 6
    PASSWORD_MAX     = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED 
    EMAIL_ADDR_MAX   = 255
    EMAIL_DOMAIN_MAX = 255
    GROUP_NAME_MAX   = 16
    GROUP_DISPLAY_NAME_MAX = 64
    TAGLINE_MAX      = 250
    UPDATE_MAX       = 1000
    COMMENT_MAX      = 1000
  end

  class Sizes
    IMAGE_FILE_MAX = 5.megabytes
  end

  class Regex
    EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    EMAIL_DOMAIN = /\A[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    GROUP = /\A[\w+\-]+\z/i
    USER  = /\A[\w+\-]+\z/i
  end

  class ExpirationTimes
    PASSWORD_RESET_EXPIRATION_HOURS = 2
    
    def ExpirationTimes.password_reset_expiration
      PASSWORD_RESET_EXPIRATION_HOURS.hours.ago
    end
  end

  VALIDATION_FLASH_LEVEL = :danger

  DEFAULT_RECORDS_PER_PAGE = 10

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

  class Locations
    INPUT_OPTIONS = [
      ["1 mile",     1],
      ["5 miles",    5],
      ["10 miles",   10],
      ["50 miles",   50],
      ["100 miles",  100],
      ["200 miles",  200],
      ["500 miles",  500],
      ["1000 miles", 1000],
      ["2000 miles", 2000],
      ["5000 miles", 5000],
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

    def Timespans.full_time(t)
      if t.year != Time.zone.now.year
        t.strftime "%b %e %Y at %l:%M:%S %p"
      else
        t.strftime "%b %e at %l:%M:%S %p"
      end
    end

    INACTIVITY_WARN_THRESHOLD = 25  # in percent

    def Timespans.time_ago(t, present: false)
      if (Time.zone.now - t).abs < 7.days
        (present ? "in " : "") + ActionController::Base.helpers.time_ago_in_words(t) + (present ? "" : " ago")
      elsif t.year != Time.zone.now.year
        (present ? "on " : "") + t.strftime("%b %e, %Y")
      else
        (present ? "on " : "") + t.strftime("%b %e")
      end
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

  class Votes
    NO = 1
    YES = 2
  end
end
