class LocationChangeTypes
  @change_types = {
    add:        1,
    remove_all: 3,
  }

  def LocationChangeTypes.[](key)
    @change_types[key]
  end

  def LocationChangeTypes.key?(key)
    @change_types.key?(key)
  end

  def LocationChangeTypes.value?(value)
    @change_types.value?(value)
  end

  def LocationChangeTypes.values
    @change_types.values
  end

end
