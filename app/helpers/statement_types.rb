class StatementTypes
  @statement_types = {
    # initial group state
    initial_statement:         1,

    # participation filters
    group_email_domain_change: 1001,
    add_facebook_filter:       1003,
    rem_facebook_filter:       1004,
    location:                  1005,
    rem_location_filter:       1006,
    invitation:                1007,

    # rules
    rule:                      2001,

    # data
    cover_photo:               3001,
    profile_image:             3002,
    tagline:                   3003,
    photo:                     3004,
    update:                    3005,
    display_name:              3006,
  }

  @type_syms = {
    1    => :initial_statement,
    1001 => :group_email_domain_change,
    1005 => :location,
    1007 => :invitation,
    2001 => :rule,
    3001 => :cover_photo,
    3002 => :profile_image,
    3003 => :tagline,
    3004 => :photo,
    3005 => :update,
    3006 => :display_name,
  }

  @tables = {
    initial_statement:         InitialGroup,
    group_email_domain_change: GroupEmailDomainChange,
    location:                  Location,
    invitation:                Invitation,
    rule:                      Rule,
    cover_photo:               nil,
    profile_image:             ProfileImage,
    tagline:                   Tagline,
    photo:                     nil,
    update:                    Update,
    display_name:              DisplayName,
  }

  @type_names = {
    1    => "First Statement",
    
    # participation filters
    1001 => "Email Address Change",
    1003 => "add_facebook_filter",
    1004 => "rem_facebook_filter",
    1005 => "Location",
    1006 => "rem_location_filter",
    1007 => "Invitation Change",
    
    # rules
    2001 => "Rule Change",
    
    # data
    3001 => "Cover Photo",
    3002 => "Profile Image",
    3003 => "Tagline",
    3004 => "Photo",
    3005 => "Status Update",
    3006 => "Name", 
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

  def StatementTypes.name_from_sym(sym)
    @type_names[@statement_types[sym]]
  end

  def StatementTypes.sym(value)
    @type_syms[value]
  end

  def StatementTypes.table(key)
    @tables[key]
  end

  def StatementTypes.full_tables
    @tables
  end
end
