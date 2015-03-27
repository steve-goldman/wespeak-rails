class StatementStates
  @statement_states = {
    alive:    1,
    dead:     2,
    voting:   3,
    accepted: 4,
    rejected: 5,
  }

  @statement_pages = {
    alive:    :proposals,
    voting:   :votes,
    accepted: :profile,
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

  def StatementStates.page(key)
    @statement_pages[key]
  end

end
