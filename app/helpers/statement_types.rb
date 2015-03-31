class StatementTypes
  @statement_types = {
    # participation filters
    group_email_domain_change: 1001,
    add_facebook_filter:       1003,
    rem_facebook_filter:       1004,
    add_location_filter:       1005,
    rem_location_filter:       1006,
    invitation:                1007,

    # rules
    rule:                      2001,

    # data
    cover_photo:               3001,
    profile_photo:             3002,
    tagline:                   3003,
    photo:                     3004,
    update:                    3005,
  }

  @type_syms = {
    1001 => :group_email_domain_change,
    1007 => :invitation,
    2001 => :rule,
    3001 => :cover_photo,
    3002 => :profile_photo,
    3003 => :tagline,
    3004 => :photo,
    3005 => :update
  }

  @tables = {
    group_email_domain_change: GroupEmailDomainChange,
    invitation:                Invitation,
    rule:                      Rule,
    cover_photo:               nil,
    profile_photo:             nil,
    tagline:                   Tagline,
    photo:                     nil,
    update:                    Update,
  }

  @type_names = {
    # participation filters
    1001 => "Email Address Change",
    1003 => "add_facebook_filter",
    1004 => "rem_facebook_filter",
    1005 => "add_location_filter",
    1006 => "rem_location_filter",

    # rules
    2001 => "Rule Change",
    
    # data
    3001 => "Cover Photo",
    3002 => "Profile Photo",
    3003 => "Tagline",
    3004 => "Photo",
    3005 => "Update",
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

  def StatementTypes.sym(value)
    @type_syms[value]
  end

  def StatementTypes.table(key)
    @tables[key]
  end

  def StatementTypes.full_table
    @tables
  end
end
