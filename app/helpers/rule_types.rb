class RuleTypes
  @rule_types = {
    lifespan:           1001,
    support_needed:     1002,
    votespan:           1003,
    votes_needed:       1004,
    yeses_needed:       1005,
    inactivity_timeout: 1006,
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

end
