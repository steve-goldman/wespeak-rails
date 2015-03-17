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

  def redirect_with_flash(object, link)
    put_flash(object)
    redirect_to link
  end

  def put_flash_now(flash_message)
    flash.now[flash_message.level] ||= []
    flash.now[flash_message.level] << flash_message.message
  end

  def render_with_flash(object, render_options)
    put_flash_now(object)
    render render_options
  end

  def put_validation_flash(object)
    object.validation_keys.each do |key|
      if !object.errors.messages[key].nil?
        flash[VALIDATION_FLASH_LEVEL] ||= []
        flash[VALIDATION_FLASH_LEVEL] << object.errors.messages[key].first
      end
    end
  end

  def put_validation_flash_now(object)
    object.validation_keys.each do |key|
      if !object.errors.messages[key].nil?
        flash.now[VALIDATION_FLASH_LEVEL] ||= []
        flash.now[VALIDATION_FLASH_LEVEL] << object.errors.messages[key].first
      end
    end
  end

end
