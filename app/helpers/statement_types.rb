class StatementTypes
  @statement_types = {
    # participation filters
    add_email_domain_filter: 1001,
    rem_email_domain_filter: 1002,
    add_facebook_filter:     1003,
    rem_facebook_filter:     1004,
    add_location_filter:     1005,
    rem_location_filter:     1006,

    # rules
    lifespan:                2001,
    support_needed:          2002,
    votespan:                2003,
    votes_needed:            2004,
    yeses_needed:            2005,
    inactivity_timeout:      2006,

    # data
    cover_photo:             3001,
    profile_photo:           3002,
    tagline:                 3003,
    photo:                   3004,
    text:                    3005,
  }

  def StatementTypes.[](key)
    @statement_types[key]
  end

  def StatementTypes.key?(key)
    @statement_types.key?(key)
  end

  def StatementTypes.value?(value)
    @statement_types.value?(value)
  end

end
