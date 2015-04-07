class StatementStates
  @statement_states = {
    new:      0,
    alive:    1,
    dead:     2,
    voting:   3,
    accepted: 4,
    rejected: 5,
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

end
