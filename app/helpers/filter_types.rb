class FilterTypes
  @filter_types = {
    email_domain: 1001,
    facebook:     1002,
    location:     1003,
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
