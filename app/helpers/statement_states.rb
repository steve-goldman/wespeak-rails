class StatementStates
  @statement_states = {
    new:      0,
    alive:    1,
    dead:     2,
    voting:   3,
    accepted: 4,
    rejected: 5,
  }

  @state_syms = {
    1 => :alive,
    2 => :dead,
    3 => :voting,
    4 => :accepted,
    5 => :rejected,
  }

  @descriptions = {
    alive:    "These statements must gain more support before having a vote.",
    dead:     "These statements will not have a vote because they did not get the support they needed in time.",
    voting:   "The group is currently voting on these statements.  Cast your votes!",
    accepted: "The group voted to adopt these statements.  They make up the official group profile.",
    rejected: "The group voted against adopting these statements.",
  }

  @names = {
    alive:    "Alive",
    dead:     "Dead",
    voting:   "Voting",
    accepted: "Passed",
    rejected: "Rejected",
  }

  def StatementStates.[](key)
    @statement_states[key]
  end

  def StatementStates.key?(key)
    @statement_states.key?(key)
  end

  def StatementStates.value?(value)
    @statement_states.value?(value)
  end

  def StatementStates.desc(key)
    @descriptions[key]
  end

  def StatementStates.name(key)
    @names[key]
  end

  def StatementStates.name_from_value(value)
    @names[@state_syms[value]]
  end
  
end
