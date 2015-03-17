module ApplicationHelper

  include Constants

  def full_title(page_title = '')
    base_title = "WeSpeak"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def put_flash(flash_message)
    flash[flash_message.level] ||= []
    flash[flash_message.level] << flash_message.message
  end

  def put_flash_now(flash_message)
    flash.now[flash_message.level] ||= []
    flash.now[flash_message.level] << flash_message.message
  end

  def put_validation_flash(object)
    object.validation_keys.each do |key|
      if !object.errors.messages[key].nil?
        flash[VALIDATION_FLASH_LEVEL] ||= []
        flash[VALIDATION_FLASH_LEVEL] << object.errors.messages[key].first
      end
    end
  end
end
