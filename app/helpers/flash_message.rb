class FlashMessage
  def initialize(level, message)
    @level = level
    @message = message
  end

  def level
    @level
  end

  def message
    @message
  end

  def to_s
    "#{@level}: #{@message}"
  end
end
