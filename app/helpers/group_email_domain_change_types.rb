class GroupEmailDomainChangeTypes
  @change_types = {
    add:        1,
    remove:     2,
    remove_all: 3,
  }

  def GroupEmailDomainChangeTypes.[](key)
    @change_types[key]
  end

  def GroupEmailDomainChangeTypes.key?(key)
    @change_types.key?(key)
  end

  def GroupEmailDomainChangeTypes.value?(value)
    @change_types.value?(value)
  end

  def GroupEmailDomainChangeTypes.values
    @change_types.values
  end
end
