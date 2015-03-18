class StatementTypes
  @statement_types = {
    email_domain_filter: 1,
    facebook_filter:     2,
    location_filter:     3,
  }

  def StatementTypes.[](key)
    @statement_types[key]
  end

  def StatementTypes.valid?(key)
    @statement_types.key?(key)
  end
end
