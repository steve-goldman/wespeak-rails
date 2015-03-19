class FilterTypes
  @filter_types = {
    email_domain_filter: 1001,
    facebook_filter:     1002,
    location_filter:     1003,
  }

  def FilterTypes.[](key)
    @filter_types[key]
  end

  def FilterTypes.key?(key)
    @filter_types.key?(key)
  end

  def FilterTypes.value?(value)
    @filter_types.value?(value)
  end

end
