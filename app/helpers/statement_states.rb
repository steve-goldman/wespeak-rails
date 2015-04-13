class StatementStates
  @statement_states = {
    new:      0,
    alive:    1,
    dead:     2,
    voting:   3,
    accepted: 4,
    rejected: 5,
  }

  @descriptions = {
    alive:    "These statements need more support to have a vote.  Support the statements you like!",
    dead:     "These statements died because they did not get enough support in the alotted time to have a vote.",
    voting:   "These statements are open for voting.  Cast your votes!",
    accepted: "These statements were voted in by the group.  They make up the official group profile.",
    rejected: "These statements were voted down by the group.",
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

end
