class RuleTypes
  @rule_types = {
    lifespan:           1001,
    support_needed:     1002,
    votespan:           1003,
    votes_needed:       1004,
    yeses_needed:       1005,
    inactivity_timeout: 1006,
  }

  @display_names = {
    lifespan:           "Statement Lifespan",
    support_needed:     "Support Needed",
    votespan:           "Vote Lifespan",
    votes_needed:       "Votes Needed",
    yeses_needed:       "Yeses Needed",
    inactivity_timeout: "Inactivity Timeout",
  }

  def RuleTypes.[](key)
    @rule_types[key]
  end

  def RuleTypes.key?(key)
    @rule_types.key?(key)
  end

  def RuleTypes.value?(value)
    @rule_types.value?(value)
  end

  def RuleTypes.values
    @rule_types.values
  end

  def RuleTypes.display_name(key)
    @display_names[key]
  end

end
