class RuleDefaults
  @rule_defaults = {
    lifespan:           3.days.to_i,
    support_needed:     10,               # 10%
    votespan:           1.day.to_i,
    votes_needed:       40,               # 40%
    yeses_needed:       50,               # 50%
    inactivity_timeout: 5.days.to_i,
  }

  def RuleDefaults.[](key)
    @rule_defaults[key]
  end

  def RuleDefaults.key?(key)
    @rule_defaults.key?(key)
  end

end
