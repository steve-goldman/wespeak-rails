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
    lifespan_rule:           2001,
    support_needed_rule:     2002,
    votespan_rule:           2003,
    votes_needed_rule:       2004,
    yeses_needed_rule:       2005,
    inactivity_timeout_rule: 2006,

    # data
    cover_photo:             3001,
    profile_photo:           3002,
    tagline:                 3003,
    photo:                   3004,
    text:                    3005,
  }

  @type_names = {
    # participation filters
    1001 => "add_email_domain_filter",
    1002 => "rem_email_domain_filter",
    1003 => "add_facebook_filter",
    1004 => "rem_facebook_filter",
    1005 => "add_location_filter",
    1006 => "rem_location_filter",

    # rules
    2001 => "lifespan_rule",
    2002 => "support_needed_rule",
    2003 => "votespan_rule",
    2004 => "votes_needed_rule",
    2005 => "yeses_needed_rule",
    2006 => "inactivity_timeout_rule",
    
    # data
    3001 => "Cover Photo",
    3002 => "Profile Photo",
    3003 => "Tagline",
    3004 => "Photo",
    3005 => "Text",
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

  def StatementTypes.name(value)
    @type_names[value]
  end

end
