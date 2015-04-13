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

  @descriptions = {
    lifespan:
      "After this much time, a statement that does not have enough
       support becomes a dead statement and will not have a vote.",

    support_needed:
      "A statement needs this much support to have a vote, as a
       percentage of the active members in the group.  When
       \"#{@display_names[:support_needed]}\" is low, the group will
       vote on more statements.  When it is high, the group will vote
       on fewer statements.",

    votespan:
      "This is how long group members have to cast their votes once a
       vote begins.",

    votes_needed:
      "At least this percentage of active members must vote -- YES or
       NO -- in order for a statement to pass.  This is one of two
       requirements for a statement to pass.  See
       \"#{@display_names[:yeses_needed]}\" for the other.",

    yeses_needed:
      "At least this percentage of votes cast must be YES in order for
       a statement to pass.  This is one of two requirements for a
       statement to pass.  See \"#{@display_names[:votes_needed]}\"
       for the other.",

    inactivity_timeout:

      "An active member that does not participate in the group -- by
       creating, supporting, or voting on a statement, or by clicking
       \"Extend Membership\" -- becomes inactive and cannot support or
       vote on statements until he or she becomes active again.",

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

  def RuleTypes.description(key)
    @descriptions[key]
  end

end
