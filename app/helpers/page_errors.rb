module PageErrors

  def PageErrors.clear
    @errors = []
  end

  def PageErrors.add_error(error)
    add_errors([error])
  end
  
  def PageErrors.add_errors(errors)
    get_instance.concat(errors)
  end
  
  def PageErrors.get
    get_instance.clone
  end
  
  # TODO: how can i hide this method?
  def PageErrors.get_instance
    if @errors.nil?
      @errors = []
    else
      @errors
    end
  end

end
